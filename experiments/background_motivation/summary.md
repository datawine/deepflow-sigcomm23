# Motivation summary

## Coverage of current distributed framework

|  | Zipkin | Jaeger | Pinpoint | Skywalking |
| ---- | ---- | ---- | ---- | ---- |
| Host/VM Network | None | None | None | Support (ref) |
| Container Network | None | None | None | Support (ref) |
| Gateway | None | None | None | None |
| Envoy (service proxy) | Support | None | None | Support |
| CoreDNS (Service Discovery) | Support | None | None | None |
| redis (caching systems) | Support | None | Support | None |
| mysql (database) | Support | Support | Support | Support (note: metrics only)  |
| nginx reverse proxies | Support | Support | Support | Support |

## Language support efforts of current distributed framework

|  | Zipkin | Jaeger | Pinpoint | Skywalking (note: logging/metrics/tracing都有，不准确) |
| ---- | ---- | ---- | ---- | ---- |
| C/C++ | 20996 / 22819 | 20851 / 22641 | 9516 / 23954 | 2562 / 3365 |
| Java | 59890 / 69596 | 12386 / 14417 | 553 / 1105 (note) | 112584 / 172136 |
| Js | 8918 / 11443 | 9104 / 18697 | 20473 / 22363 | 3868 / 14014 |
| Golang | 8653 / 8904 | 27253 / 28585 | 18781 / 21303 | 5353 / 6288 |
| Python | 5714 / 6354 | 8908 / 9734 | 2353 / 23954 (note) | 6331 / 11892 |