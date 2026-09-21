# 计算机网络

## 一次页面请求发生了什么

1. DNS 解析域名
2. TCP 三次握手（HTTP/3 走 QUIC，省掉这一步）
3. TLS 握手（HTTPS）
4. 发 HTTP 请求，服务端返回响应
5. 浏览器解析、渲染
6. 四次挥手（或连接复用保持）

## 缓存优先级

强缓存（`Cache-Control`、`Expires`）命中就不发请求；协商缓存（`ETag`/`If-None-Match`、`Last-Modified`/`If-Modified-Since`）会发请求，服务端答 304 表示「用你本地的」。

## 跨域

同源策略限制的是「读响应」，不是「发请求」。CORS 预检请求 `OPTIONS` 携带 `Access-Control-Request-Method`，服务端需要回 `Access-Control-Allow-*` 头。
