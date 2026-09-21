# HTML

## 语义化

语义化的收益不在「好看」，而在于可访问性和可维护性：屏幕阅读器、搜索引擎、以及半年后的你自己。

```html
<!-- 不推荐 -->
<div class="header">
  <div class="nav">...</div>
</div>

<!-- 推荐 -->
<header>
  <nav>...</nav>
</header>
```

## 常用元信息

```html
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="页面摘要">
```

`viewport` 那行不加，移动端会用 980px 的虚拟视口渲染，响应式基本失效。
