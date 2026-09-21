# CS & FE Wiki

计算机基础与前端的个人知识库，基于 [VitePress](https://vitepress.dev) 构建，
发布在 GitHub Pages。

线上地址：`https://redkold.github.io/nju-cs-fe/`

## 本地开发

```bash
npm install        # 首次
npm run docs:dev   # 启动开发服务器，改 md 会自动热更新
```

开发服务器默认在 http://localhost:5173。

## 构建与预览产物

```bash
npm run docs:build     # 产物在 docs/.vitepress/dist
npm run docs:preview   # 本地预览构建产物
```

`docs/.vitepress/dist` 是纯粹的静态 HTML/CSS/JS，可以直接丢给任意静态托管。
这个目录已加入 `.gitignore`，不需要提交。

## 目录结构

```text
.
├── docs/
│   ├── .vitepress/
│   │   ├── config.mts        # 站点配置：导航、侧边栏、搜索、主题色
│   │   └── theme/custom.css  # 自定义配色
│   ├── public/logo.svg       # 静态资源，原样拷贝到产物根目录
│   ├── index.md              # 首页（hero + features）
│   ├── web/                  # 前端
│   ├── cs/                   # 计算机基础
│   └── engineering/          # 工程化
├── .github/workflows/deploy.yml   # 推送到 main 后自动构建并发布
└── package.json
```

## 新增文章

1. 在 `docs/<板块>/` 下新建 `xxx.md`，用一级标题开头；
2. 在 `docs/.vitepress/config.mts` 对应的 `sidebar` 里加一行：

```ts
{ text: '显示的名字', link: '/板块/xxx' }
```

标题层级建议只用到 `##` 和 `###`，`###` 以上会自动出现在右侧「本页目录」。

## 部署

推送到 `main` 分支后，GitHub Actions 自动构建并部署，约 1～2 分钟生效。

`config.mts` 里的 `BASE` 必须和仓库名保持一致（当前是 `/nju-cs-fe/`）。
如果仓库改名为 `<用户名>.github.io`，把 `BASE` 改成 `'/'`。
