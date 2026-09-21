#!/usr/bin/env bash
#
# 计算当前分支对应的「创建 Pull Request」链接。
# 由 `make pr` 调用，也可以单独执行：bash scripts/pr-link.sh [分支名]
#
# 同时兼容两种情况：
#   - origin 就是上游仓库（有写权限的协作者）
#   - origin 是自己的 fork（没有写权限的贡献者），此时链接需要带 fork 用户名

set -euo pipefail

UPSTREAM="${UPSTREAM_REPO:-RedKold/nju-cs-fe}"
branch="${1:-$(git rev-parse --abbrev-ref HEAD)}"

url="$(git remote get-url origin)"
url="${url%.git}"

# git@github.com:owner/repo 和 https://github.com/owner/repo 都能解析成 owner/repo
owner_repo="$(printf '%s' "$url" | awk -F'[:/]' '{print $(NF-1)"/"$NF}')"

if [ "$owner_repo" = "$UPSTREAM" ]; then
  printf 'https://github.com/%s/compare/main...%s?expand=1\n' "$UPSTREAM" "$branch"
else
  owner="${owner_repo%%/*}"
  printf 'https://github.com/%s/compare/main...%s:%s?expand=1\n' "$UPSTREAM" "$owner" "$branch"
fi
