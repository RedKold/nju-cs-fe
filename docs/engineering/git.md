# Git 工作流

## 常用命令

```bash
git switch -c feat/login      # 建分支并切过去
git add -p                    # 交互式挑选要提交的块
git commit --amend            # 修补上一条提交
git rebase -i main            # 整理本地提交
```

## 提交信息约定

```text
feat: 增加登录接口
fix: 修复移动端输入框失焦
docs: 补充部署文档
refactor: 抽离请求层
```

## 遇到冲突

先 `git status` 看冲突文件，手工解决后 `git add`，再继续 `rebase --continue` 或直接提交。冲突时不要用 `git checkout --ours/theirs` 无脑盖掉，容易丢别人的改动。

> 本文档仓库自己也是 git 仓库，但注意：`git reset --hard`、`git checkout --` 这类命令会丢弃未提交改动，用之前先确认。
