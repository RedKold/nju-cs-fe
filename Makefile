# 南京大学计算机金融实验班资料库 —— 日常维护命令
#
# 直接运行 `make` 会列出所有可用命令。
#
# 贡献者：make install → make branch → make dev → make check → make pr
# 维护者：make publish（只允许在 main 上执行）

SHELL := /bin/bash

DOCS     := docs
DIST     := $(DOCS)/.vitepress/dist
MSG      ?= docs: 更新站点内容

# 上游仓库，用于生成 Pull Request 链接
UPSTREAM_REPO ?= RedKold/nju-cs-fe
export UPSTREAM_REPO

.DEFAULT_GOAL := help
.PHONY: help install dev build preview check new branch pr publish sync status clean

help: ## 显示所有可用命令
	@echo "南京大学计算机金融实验班资料库"
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo "  贡献者典型流程：make branch NAME=feat/xxx  →  改内容  →  make pr"
	@echo "  自定义提交信息：make pr MSG=\"docs: 补充夏令营经验\""

node_modules: package.json package-lock.json
	@echo "安装依赖…"
	@npm install
	@touch node_modules

install: node_modules ## 安装依赖（首次使用）

dev: node_modules ## 启动本地开发服务器（热更新，默认 5173 端口）
	@echo "提示：新增 .md 文件后侧边栏不会立刻更新，在服务器里按 r 重启即可。"
	@npm run docs:dev

build: node_modules ## 构建静态站点到 docs/.vitepress/dist
	@npm run docs:build

preview: build ## 本地预览构建产物（检查线上效果）
	@npm run docs:preview

check: ## 提交前检查：死链、漏挂页面、裸链接、大文件
	@bash scripts/check.sh
	@echo
	@echo "构建检查（VitePress 会额外校验站内死链）…"
	@npm run --silent docs:build

new: ## 新建一篇文章（自动生成骨架并提示侧边栏写法）
	@read -p "板块 [guide/courses/postgrad/abroad/career/resources]: " sect; \
	read -p "文件名（英文小写，如 math）: " slug; \
	read -p "页面标题: " title; \
	file="$(DOCS)/$$sect/$$slug.md"; \
	if [ ! -d "$(DOCS)/$$sect" ]; then \
		echo "板块不存在：$(DOCS)/$$sect"; exit 1; \
	fi; \
	if [ -f "$$file" ]; then \
		echo "文件已存在：$$file"; exit 1; \
	fi; \
	{ \
		echo "# $$title"; \
		echo; \
		echo "> ⚠️ 待核对：本页内容尚未核实，请以官方文件为准。"; \
		echo; \
		echo "## 小节"; \
		echo; \
		echo "待补充。"; \
	} > "$$file"; \
	echo; \
	echo "已创建 $$file"; \
	echo "它会自动出现在侧边栏，不用改任何配置。"; \
	echo; \
	echo "想调整它在侧边栏里的位置，在文件开头加 frontmatter："; \
	echo "  ---"; \
	echo "  order: 3"; \
	echo "  ---"; \
	echo "数字越小越靠前；不写 order 的排在写了 order 的后面。"

branch: ## 从最新 main 新建工作分支：make branch NAME=feat/夏令营经验
	@set -e; \
	if [ -z "$(NAME)" ]; then \
		echo "用法：make branch NAME=feat/你的主题"; \
		echo "命名建议：feat/ 新增内容，fix/ 修正错误，docs/ 纯文档调整"; \
		exit 1; \
	fi; \
	if ! git show-ref --verify --quiet refs/heads/main; then \
		echo "本地没有 main 分支，先执行：git fetch origin main:main"; \
		exit 1; \
	fi; \
	git switch main; \
	if git remote | grep -qx upstream; then \
		git pull --ff-only upstream main; \
	else \
		git pull --ff-only; \
	fi; \
	git switch -c "$(NAME)"; \
	echo; \
	echo "已切到分支 $(NAME)，现在可以改内容。"; \
	echo "改完先 make dev 看效果，再 make check，最后 make pr。"

pr: check ## 提交并推送当前分支，给出创建 PR 的链接（不会动 main）
	@set -e; \
	branch=$$(git rev-parse --abbrev-ref HEAD); \
	if [ "$$branch" = "main" ]; then \
		echo; \
		echo "当前在 main 分支上。PR 流程不应该直接改 main。"; \
		echo "先建分支：make branch NAME=feat/你的主题"; \
		exit 1; \
	fi; \
	git add -A; \
	if git diff --cached --quiet; then \
		echo "没有需要提交的改动。"; \
	else \
		git commit -m "$(MSG)"; \
	fi; \
	git push -u origin "$$branch"; \
	echo; \
	echo "分支已推送。打开下面链接创建 Pull Request："; \
	echo "  $$(bash scripts/pr-link.sh "$$branch")"

publish: check ## 仅维护者：在 main 上直接提交并推送（贡献者请用 make pr）
	@set -e; \
	branch=$$(git rev-parse --abbrev-ref HEAD); \
	if [ "$$branch" != "main" ]; then \
		echo; \
		echo "当前在 $$branch 分支上，publish 只允许在 main 上执行。"; \
		echo "想提 PR 用：make pr"; \
		echo "想回主线：git switch main"; \
		exit 1; \
	fi; \
	git add -A; \
	if git diff --cached --quiet; then \
		echo "没有需要提交的改动。"; \
		exit 0; \
	fi; \
	git commit -m "$(MSG)"; \
	git push -u origin main; \
	echo; \
	echo "已推送，约 1～2 分钟后生效：https://redkold.github.io/nju-cs-fe/"

sync: ## 切回 main 并拉取最新代码
	@set -e; \
	git switch main; \
	if git remote | grep -qx upstream; then \
		echo "从 upstream 拉取…"; \
		git pull --ff-only upstream main; \
	else \
		git pull --ff-only; \
	fi

status: ## 查看分支、上游与仓库状态
	@echo "当前分支：$$(git rev-parse --abbrev-ref HEAD)"
	@echo "上游分支：$$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo '未设置（首次 push 会自动设置）')"
	@echo
	@git status --short --branch
	@echo
	@git log --oneline -5

clean: ## 清理构建产物与缓存
	@rm -rf "$(DIST)" "$(DOCS)/.vitepress/.temp" "$(DOCS)/.vitepress/cache"
	@echo "已清理构建产物与缓存。"
