# CSS

## 盒模型

默认 `box-sizing: content-box`，`width` 只算内容区。工程里通常全局改成 `border-box`：

```css
*, *::before, *::after {
  box-sizing: border-box;
}
```

## 布局选择

- 一维排列 → Flexbox
- 二维网格 → Grid
- 页面级分区 → Grid，块内部 → Flex

```css
.page {
  display: grid;
  grid-template-columns: 240px 1fr;
  min-height: 100vh;
}
```

## 重排与重绘

改 `width`、`top` 会触发重排；改 `color`、`background` 只触发重绘；`transform` 和 `opacity` 可以只走合成层，所以动画优先用它们。
