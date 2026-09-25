# 南京大学计算机金融实验班资料库

面向本专业在读学生的资料与经验库，覆盖**课程资料**、**推免**、**出国**、
**实习就业**四条线，外加一个只放下载链接的**资源区**。

**目前正在监修中**，部分内容可能为AI生成的占位符，请谨慎参考。

线上地址：<https://redkold.github.io/nju-cs-fe/>

## 内容结构

| 板块 | 目录 | 内容 |
| --- | --- | --- |
| 使用指南 | `docs/guide/` | 使用说明、培养方案与课程地图、四年时间线 |
| 课程资料 | `docs/courses/` | 数学统计 / 计算机 / 金融经济三条线的课程清单与学习重点 |
| 推免 | `docs/postgrad/` | 政策资格、夏令营、材料准备、面试经验 |
| 出国 | `docs/abroad/` | 申请时间线、选校与文书、语言考试 |
| 实习就业 | `docs/career/` | 方向介绍、实习节奏、量化岗位技能栈 |
| 资源区 | `docs/resources/` | 教材课件、历年真题、模板的下载链接 |

## 日常维护

常用操作都收在 `Makefile` 里，直接运行 `make` 会列出全部命令。

```bash
make install    # 首次安装依赖
make dev        # 启动本地开发服务器（热更新，默认 5173 端口）
make new        # 新建一篇文章，自动生成文件并提示侧边栏写法
make check      # 提交前检查：死链、漏挂页面、裸链接、大文件
make clean      # 清理构建产物与缓存
```

### 贡献者：走 PR 流程

仓库采用 PR 流程，改动经审阅合并进 `main` 后才会部署上线。

```bash
make branch NAME=feat/夏令营经验   # 从最新 main 建分支
make dev                          # 写作与预览
make check                        # 自查
make pr MSG="docs: 补充夏令营经验"   # 提交、推送，并打印 PR 链接
```

没有写权限的同学先 Fork 仓库，再把原仓库加为 `upstream`，`make branch` 会自动从上游拉取：

```bash
git remote add upstream git@github.com:RedKold/nju-cs-fe.git
```

详细说明见[如何贡献](https://redkold.github.io/nju-cs-fe/guide/contributing)。

### 维护者：直接发布

```bash
make sync                         # 切回 main 并拉取最新代码
make publish MSG="docs: ..."      # 只允许在 main 上执行，直接上线
```

`make pr` 和 `make publish` 都会先跑 `make check`，**检查不通过就不会提交**，避免把死链推到线上。
提交信息默认是 `docs: 更新站点内容`，用 `MSG=` 可以覆盖。

### make check 具体查什么

| 检查项 | 拦截的问题 |
| --- | --- |
| 板块目录 | 板块缺少 `index.md`，或新增目录后忘了登记到 `sidebar.ts` |
| 硬编码链接 | `sidebar.ts` 里的跨板块链接指向不存在的页面 |
| 页面标题 | 页面没有一级标题，侧边栏会退化成显示文件名 |
| 裸链接 | `[文字](box.nju.edu.cn)` 这种缺 `https://` 的写法，发布后必然 404 |
| 大文件 | 超过 50 MB 的文件，GitHub 单文件上限 100 MB 且提交后无法轻易删除 |

此外 `make check` 会先构建一次，VitePress 自带的死链检测也在这一步生效。

## 新增文章

**侧边栏和顶部导航根据目录结构自动生成**（见 `docs/.vitepress/sidebar.ts`），
新增页面不需要修改任何配置文件。

推荐用 `make new`，它会引导你填板块、文件名和标题，自动生成带标准骨架的文件：

```bash
make new
```

也可以直接在对应板块目录下新建 `xxx.md`。侧边栏显示的文字优先取正文的一级标题；
想调整排序，就在文件开头加 `order`：

```markdown
---
order: 3
---

# 夏令营
```

`index.md` 永远排第一，没写 `order` 的排在写了 `order` 的后面。
完整规则见[如何贡献](https://redkold.github.io/nju-cs-fe/guide/contributing)。

正文标题层级建议只用到 `##` 和 `###`，它们会自动出现在右侧「本页目录」。

只有在**新增整个板块**时，才需要动 `sidebar.ts`：在 `SECTIONS` 数组里加一行即可。

## 贡献约定

- **不要把大文件提交进 git。** GitHub 单文件超过 100 MB 会被拒绝推送，
  且一旦提交就会永久留在历史里。课件、真题、录屏一律走外部链接，
  详见资源区的说明。
  - 你可以灵活使用 [nju-box](https://box.nju.edu.cn)
- 涉及硬性规定（名额、学分、资格线）时，注明来源和时效并写「以官方文件为准」。
- 还没核实的条目请标注 `⚠️ 待核对`，不要让读者误当成结论。

## 部署

推送到 `main` 分支后，GitHub Actions 自动构建并部署，约 1～2 分钟生效。

首次部署需要在仓库 `Settings → Pages` 里把 **Source** 设为 **GitHub Actions**。
工作流里的 `actions/configure-pages` 已开启 `enablement`，正常情况下会自动完成。

`docs/.vitepress/config.mts` 里的 `BASE` 必须和仓库名保持一致（当前 `/nju-cs-fe/`）。

## 免责声明

站内经验性内容来自同学的个人经历，政策与培养方案每年可能调整。
凡涉及资格、名额、学分的硬性规定，**一律以学院和教务处的当年官方文件为准**。
