# 构建与打包

## 为什么需要构建

浏览器不认识 JSX、TypeScript、`import` 裸模块名，也不适合直接加载上百个源文件。构建做的事就是：转译 + 合并/拆分 + 压缩 + 资源指纹。

## 关键概念

- **Tree Shaking**：靠 ESM 的静态分析删掉没用的导出，副作用标记 `sideEffects` 会影响它
- **Code Splitting**：按路由或动态 `import()` 拆包，首屏只加载需要的
- **HMR**：热更新，改代码不刷新页面

```js
// 动态导入，会被拆成独立 chunk
const { default: Editor } = await import('./editor.js');
```

another cpp test

```cpp
const int x = 6;
printf("%d", x);
```

## 产物体积排查

先看构建工具的 bundle 分析输出，再定位是哪个依赖进来的。常见坑：整包引入 lodash、moment 带了所有语言包、图标库全量引入。
