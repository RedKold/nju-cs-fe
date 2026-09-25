#!/usr/bin/env bash
#
# 站内一致性检查。由 `make check` 调用，也可以单独执行：bash scripts/check.sh
#
# 只依赖 grep / awk / find / sort，这些在任何 macOS 和 Linux 上都自带，
# 不需要额外安装 ripgrep。
#
# 检查四件事：
#   1. 板块目录完整：每个板块都有 index.md，且登记在 sidebar.ts 的 SECTIONS 里；
#      sidebar.ts 与 config.mts 中硬编码的链接都能解析到真实文件
#   2. 每个页面都有标题 —— 侧边栏显示的文字就取自这里
#   3. 是否有缺少协议头的链接（会变成相对路径死链）
#   4. 是否有超过 GitHub 限制的大文件

set -uo pipefail

DOCS="docs"
SIDEBAR="${DOCS}/.vitepress/sidebar.ts"
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

# 站内页面（只含 docs/）
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
echo "1/4  板块目录与侧边栏配置"
sections=0
dir_problems=""
while IFS= read -r d; do
  name="$(basename "$d")"
  sections=$((sections + 1))
  [ -f "${d}/index.md" ] || dir_problems="${dir_problems}  ${d}/ 缺少 index.md"$'\n'
  grep -q "dir: '${name}'" "$SIDEBAR" \
    || dir_problems="${dir_problems}  ${name}/ 没有登记在 ${SIDEBAR} 的 SECTIONS 里"$'\n'
done < <(find "$DOCS" -mindepth 1 -maxdepth 1 -type d \
           -not -name '.vitepress' -not -name 'public' | sort)

link_problems=""
links=0
while IFS= read -r p; do
  [ -z "$p" ] && continue
  case "$p" in http*|mailto:*|'#'*) continue ;; esac
  links=$((links + 1))
  resolve "$p" || link_problems="${link_problems}  ${p}"$'\n'
done < <(grep -hoE "link: '[^']*'" "$SIDEBAR" "$CONFIG" | awk -F"'" '{print $2}' | sort -u)

if [ -n "$dir_problems" ] || [ -n "$link_problems" ]; then
  [ -n "$dir_problems" ] && { fail "板块目录有问题："; dim "$dir_problems"; }
  [ -n "$link_problems" ] && { fail "以下链接指向不存在的文件："; dim "$link_problems"; }
elif [ "$sections" -eq 0 ]; then
  fail "没有在 ${DOCS}/ 下找到任何板块目录，检查脚本可能已失效"
else
  green "  ✓ ${sections} 个板块目录结构完整，${links} 个硬编码链接有效"
fi

echo "2/4  页面标题（决定侧边栏显示的文字）"
missing_title=""
while IFS= read -r f; do
  [ "$f" = "${DOCS}/index.md" ] && continue   # 首页是 layout: home，不需要标题
  has=$(awk '
    NR == 1 && $0 == "---" { infm = 1; next }
    infm && /^---[[:space:]]*$/ { infm = 0; next }
    infm && /^title:/ { print "yes"; exit }
  ' "$f")
  if [ -z "$has" ]; then
    has=$(awk '
      /^[[:space:]]*```/ { inblock = !inblock; next }
      inblock { next }
      /^# / { print "yes"; exit }
    ' "$f")
  fi
  [ -z "$has" ] && missing_title="${missing_title}  ${f}"$'\n'
done < <(site_pages)

if [ -n "$missing_title" ]; then
  fail "以下页面没有一级标题或 frontmatter title，侧边栏会显示文件名："
  dim "$missing_title"
else
  green "  ✓ 所有页面都有标题"
fi

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
