# JavaScript

## 事件循环

同步代码 → 微任务队列清空 → 渲染 → 下一个宏任务。

```js
console.log('1');
setTimeout(() => console.log('2'), 0);
Promise.resolve().then(() => console.log('3'));
console.log('4');

// 输出：1 4 3 2
```

微任务是「当前宏任务结束前必须清空」的，所以 `Promise` 永远先于 `setTimeout`。

## 闭包

闭包 = 函数 + 它定义时的词法环境。循环里绑事件最容易踩：

```js
// 用 let，每轮都有独立绑定
for (let i = 0; i < 3; i++) {
  setTimeout(() => console.log(i), 0);
}

// 用 var 只有一份 i，输出 3 3 3
```
