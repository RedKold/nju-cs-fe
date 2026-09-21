# 南京大学计算机金融实验班资料库 —— 日常维护命令
#
# 直接运行 `make` 会列出所有可用命令。

SHELL := /bin/bash

DOCS     := docs
CONFIG   := $(DOCS)/.vitepress/config.mts
DIST     := $(DOCS)/.vitepress/dist
MSG      ?= docs: 更新站点内容

.DEFAULT_GOAL := help
.PHONY: help install dev build preview check new publish status clean

help: ## 显示所有可用命令
	@echo "南京大学计算机金融实验班资料库"
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo "  发布时自定义提交信息：make publish MSG=\"feat: 补充推免材料\""

node_modules: package.json package-lock.json
	@echo "安装依赖…"
	@npm install
	@touch node_modules

install: node_modules ## 安装依赖

dev: node_modules ## 启动本地开发服务器（热更新，默认 5173 端口）
	@npm run docs:dev

build: node_modules ## 构建静态站点到 docs/.vitepress/dist
	@npm run docs:build

preview: build ## 本地预览构建产物（验证线上效果）
	@npm run docs:preview

check: ## 发布前检查：死链、漏挂页面、裸链接、大文件
	@bash scripts/check.sh
	@echo
	@echo "构建检查（VitePress 会额外校验站内死链）…"
	@npm run --silent docs:build

new: ## 新建一篇文章（自动生成文件并提示侧边栏写法）
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
	echo "记得在 $(CONFIG) 对应的 sidebar 里加一行："; \
	echo "  { text: '$$title', link: '/$$sect/$$slug' }"; \
	echo "（忘了也没关系，make check 会提醒你）"

publish: check ## 检查通过后提交并推送，触发自动部署
	@git add -A
	@if git diff --cached --quiet; then \
		echo "没有需要提交的改动。"; \
	else \
		git commit -m "$(MSG)" && git push && echo "已推送，约 1～2 分钟后生效。"; \
	fi

status: ## 查看仓库当前状态
	@git status --short --branch
	@echo
	@git log --oneline -5

clean: ## 清理构建产物与缓存
	@rm -rf "$(DIST)" "$(DOCS)/.vitepress/.temp" "$(DOCS)/.vitepress/cache"
	@echo "已清理构建产物与缓存。"
