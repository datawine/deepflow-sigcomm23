# Motivation summary

## Coverage of current distributed framework

|  | Zipkin | Jaeger | Pinpoint | Skywalking |
| ---- | ---- | ---- | ---- | ---- |
<<<<<<< HEAD:experiments/background_motivation/summary.md
| Host/VM Network | None | None | | 
| Container Network | None | None | | |
| Gateway | None | None | | |
| Envoy (service proxy) | Support | None | | |
| CoreDNS (Service Discovery) | Support | None | | |
| redis (caching systems) | Support | | | |
| mysql (database) | Support | | | |
| nginx reverse proxies | Support | | | |

## Language support efforts of current distributed framework

|  | Zipkin | Jaeger | Pinpoint | Skywalking |
| ---- | ---- | ---- | ---- | ---- |
| C/C++ | 20996 / 22819 | | | |
| Java | 59890 / 69596 | | | |
| Js | 8918 / 11443 | | | |
| Rust | 3351 / 3492 | | | |
| Golang | 8653 / 8904 | | | |
| Python | 5714 / 6354 | | | |
| PHP | 5739 / 6230 | | | |

**nginx:** does jaeger support nginx tracing(google)

https://www.alibabacloud.com/help/en/tracing-analysis/latest/use-jaeger-to-perform-tracing-analysis-on-nginx, https://sund5429.medium.com/add-jaeger-tracing-to-nginx-7de1d731ee6e

**redis:** jaeger redis(google), jaeger redis(github)

https://itnext.io/all-hail-tracing-a-go-redis-and-jaeger-tale-7904743d0fd (?)

**mysql:** jaeger mysql(google)

https://ceshihao.github.io/2018/11/29/tracing-db-operations/



#### c. languages

https://www.jaegertracing.io/docs/1.39/client-libraries/

**c/cpp:** 官网

https://github.com/jaegertracing/jaeger-client-cpp


C++ 12841
C/C++ Header 8010
CMake 959
YAML 292
Markdown 284
Python 128
Bourne Shell 121
Dockerfile 6
SUM 22641


**java:** 官网

https://github.com/jaegertracing/jaeger-client-java


Java 12386
Markdown 869
Gradle 421
Bourne Shell 226
XML 201
YAML 178
DOS Batch 59
JSON 39
make 34
Dockerfile 4
SUM 14417


**js:** 官网

https://github.com/jaegertracing/jaeger-client-node


JavaScript 9104
JSON 8730
Markdown 496
YAML 231
Bourne Shell 63
make 62
Dockerfile 11
SUM 18697


**rust:** jaeger rust(github)

https://github.com/open-telemetry/opentelemetry-rust, https://github.com/sile/rustracing_jaeger


Rust 1046
YAML 114
Markdown 44
TOML 27
SUM 1231


**golang:** 官网

https://github.com/jaegertracing/jaeger-client-go


Go 27253
Markdown 804
YAML 263
make 129
Python 57
Bourne Shell 49
TOML 24
Dockerfile 6
SUM 28585


**python:** 官网

https://github.com/jaegertracing/jaeger-client-python

Python 8908
Markdown 287
YAML 200
reStructuredText 164
make 114
Bourne Shell 28
Dockerfile 17
awk 16
SUM 9734

**php:** jaeger php(github)

https://github.com/code-tool/jaeger-client-php, https://github.com/jonahgeorge/jaeger-client-php


PHP 6717
Markdown 203
JSON 62
Bourne Shell 55
YAML 36
SUM 7073

cpp 3365+23954+22819+22641=72779 ave=18194.75
java 172136+69596+14417=256149 ave=85383
rust 3823+3492+1231=8546 ave=2848.667
go 6288+21303+8904+28585=65080 ave=16270
python 11892+23954+6354+9734=51934 ave=12983.5
php 5553+23954+356+7073=36936 ave=9234
js 22363+11443+18697=52503 ave=17501
SUM=543927
AVE=21757.08
(这个数据中，pinpoint的cpp代理被计算了三次)




1.其中pinpoint的cpp，php，python的agent在同一个仓库，是否要/3或者其他计算方法
2.pinpoint未找到java，rust相关agent
3.各个仓库差距量很大，比如zipkin的php仓库只有356行
4.skywalking未找到js相关agent
=======
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


>>>>>>> 5f0c3ed ([experiment] add summary for background and motivation):experiments/Background_Motivation/summary.md
