# 数据结构与算法

## 复杂度速查

| 结构 | 查找 | 插入 | 删除 |
| --- | --- | --- | --- |
| 数组 | O(1) 下标 / O(n) 查找 | O(n) | O(n) |
| 哈希表 | O(1) | O(1) | O(1) |
| 平衡 BST | O(log n) | O(log n) | O(log n) |
| 堆 | O(1) 取顶 | O(log n) | O(log n) |

## 二分查找模板

```js
function lowerBound(arr, target) {
  let lo = 0, hi = arr.length;
  while (lo < hi) {
    const mid = (lo + hi) >> 1;
    if (arr[mid] < target) lo = mid + 1;
    else hi = mid;
  }
  return lo;
}
```

用 `lo < hi` 加左闭右开，可以避免大量边界特判。
