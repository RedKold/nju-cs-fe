#!/usr/bin/env bash
#
# 站内一致性检查。由 `make check` 调用，也可以单独执行：bash scripts/check.sh
#
# 只依赖 grep / awk / find / sort，这些在任何 macOS 和 Linux 上都自带，
# 不需要额外安装 ripgrep。
#
# 检查四件事：
#   1. config.mts 里的导航/侧边栏链接是否都有对应文件
#   2. 是否有页面写了但没挂进侧边栏（读者点不到）
#   3. 是否有缺少协议头的链接（会变成相对路径死链）
#   4. 是否有超过 GitHub 限制的大文件

set -uo pipefail

DOCS="docs"
CONFIG="${DOCS}/.vitepress/config.mts"
FAIL=0

red()   { printf '\033[31m%s\033[0m\n' "$1"; }
green() { printf '\033[32m%s\033[0m\n' "$1"; }
dim()   { printf '\033[2m%s\033[0m\n' "$1"; }
fail()  { red "  ✗ $1"; FAIL=1; }

# 把 /guide/math 解析成 docs/guide/math.md 或 docs/guide/math/index.md
resolve() {
  local p="${1#/}"
  [ -f "${DOCS}/${p}index.md" ] && return 0
  [ -f "${DOCS}/${p}.md" ] && return 0
  return 1
}

# 站内页面（只含 docs/，用于检查是否挂进侧边栏）
site_pages() {
  find "$DOCS" -name '*.md' -not -path '*/dist/*' -not -path '*/.temp/*' | sort
}

# 所有给人看的 Markdown（含根目录文档，用于检查链接写法）
text_files() {
  site_pages
  [ -f README.md ] && echo README.md
  [ -f CONTRIBUTING.md ] && echo CONTRIBUTING.md
  return 0
}

echo
echo "1/4  导航与侧边栏链接"
checked=0
mismatch=""
while IFS= read -r p; do
  [ -z "$p" ] && continue
  # socialLinks 这类完整网址不是站内路径，跳过
  case "$p" in http*|mailto:*|'#'*) continue ;; esac
  checked=$((checked + 1))
  resolve "$p" || mismatch="${mismatch}  ${p}"$'\n'
done < <(grep -oE "link: '[^']*'" "$CONFIG" | awk -F"'" '{print $2}' | sort -u)

if [ -n "$mismatch" ]; then
  fail "配置里指向了不存在的文件："
  dim "$mismatch"
elif [ "$checked" -gt 0 ]; then
  green "  ✓ 检查了 ${checked} 个链接"
else
  fail "没有从 ${CONFIG} 里解析到任何链接，检查脚本可能已失效"
fi

echo "2/4  页面是否都挂进了侧边栏"
orphans=0
while IFS= read -r f; do
  [ -z "$f" ] && continue
  [ "$f" = "${DOCS}/index.md" ] && continue   # 首页是 layout: home，不需要挂
  rel="${f#${DOCS}/}"
  case "$rel" in
    */index.md) link="/${rel%index.md}" ;;
    *)          link="/${rel%.md}" ;;
  esac
  if ! grep -qF "link: '${link}'" "$CONFIG"; then
    fail "页面没有挂进侧边栏：${f}"
    dim "      在 config.mts 加一行：{ text: '标题', link: '${link}' }"
    orphans=$((orphans + 1))
  fi
done < <(site_pages)
[ "$orphans" -eq 0 ] && green "  ✓ 所有页面都已挂载"

echo "3/4  缺少协议头的链接"
# 形如 [nju-box](box.nju.edu.cn) 的写法会被当成相对路径，发布后必然 404
# 先剔除围栏代码块与行内代码，避免把文档里的反例当成真链接
bare=""
while IFS= read -r f; do
  [ -z "$f" ] && continue
  hits=$(awk -v file="$f" '
    /^[[:space:]]*```/ { inblock = !inblock; next }
    inblock { next }
    {
      line = $0
      gsub(/`[^`]*`/, "", line)
      while (match(line, /\]\([^)]*\)/)) {
        target = substr(line, RSTART + 2, RLENGTH - 3)
        if (target !~ /^(https?:\/\/|\/|#|mailto:|\.\.?\/)/ && target !~ /\.md$/) {
          printf "%s:%d: %s\n", file, NR, target
        }
        line = substr(line, RSTART + RLENGTH)
      }
    }' "$f")
  [ -n "$hits" ] && bare="${bare}${hits}"$'\n'
done < <(text_files)

if [ -n "$bare" ]; then
  fail "以下链接缺少 https:// 前缀："
  dim "$bare"
else
  green "  ✓ 没有裸链接"
fi

echo "4/4  大文件（GitHub 单文件上限 100 MB）"
big=$(find . -type f \
        -not -path './.git/*' \
        -not -path './node_modules/*' \
        -not -path '*/dist/*' \
        -not -path '*/.temp/*' \
        -size +50M 2>/dev/null || true)
if [ -n "$big" ]; then
  fail "以下文件超过 50 MB，请改用外部链接而不是提交进仓库："
  dim "$big"
else
  green "  ✓ 没有过大的文件"
fi

echo
if [ "$FAIL" -eq 0 ]; then
  green "全部检查通过。"
else
  red "发现问题，请先修复后再提交。"
fi
exit "$FAIL"
