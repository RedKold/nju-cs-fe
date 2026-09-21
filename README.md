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

## 本地开发

```bash
npm install        # 首次
npm run docs:dev   # 启动开发服务器，改 md 会自动热更新
```

开发服务器默认在 <http://localhost:5173>。

## 构建与预览产物

```bash
npm run docs:build     # 产物在 docs/.vitepress/dist
npm run docs:preview   # 本地预览构建产物
```

`docs/.vitepress/dist` 是纯静态 HTML/CSS/JS，可以直接丢给任意静态托管。
该目录已加入 `.gitignore`，不需要提交。

## 新增文章

1. 在对应板块目录下新建 `xxx.md`，用一级标题开头；
2. 在 `docs/.vitepress/config.mts` 对应的 `sidebar` 里加一行：

```ts
{ text: '显示的名字', link: '/板块/xxx' }
```

正文标题层级建议只用到 `##` 和 `###`，它们会自动出现在右侧「本页目录」。

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
