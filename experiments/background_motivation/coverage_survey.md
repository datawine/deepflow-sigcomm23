### Skywalking

#### a. infrastructure

**network(网卡):** skywalking network(github)

https://github.com/apache/skywalking-rover, 

https://skywalking.apache.org/docs/main/next/en/setup/backend/backend-k8s-network-monitoring/

**docker:** skywalking docker monitor(google), skywalking docker(github)

-

**envoy:** skywalking envoy proxy(google), skywalking envoy(github)

-

**vm:** skywalking vm tracing(google), 官网

https://skywalking.apache.org/blog/skywalking8-4-release/,

https://skywalking.apache.org/docs/main/next/en/setup/backend/backend-vm-monitoring/

**gateway:** 官网

https://skywalking.apache.org/docs/main/next/en/setup/backend/backend-apisix-monitoring/



#### b. basic services

**CoreDNS:** skywalking coredns(google/github)

-

**mongoDB:** skywalking mongodb(google)

https://github.com/apache/skywalking/issues/147

**nginx:** 官网

https://github.com/apache/skywalking-nginx-lua

**etcd:** skywalking etcd(google/github)

-

**redis:** skwalking redis(github)

https://github.com/qit-team/redis-go2sky-hook

**mysql:** 官网

https://skywalking.apache.org/docs/main/next/en/setup/backend/backend-mysql-monitoring/

#### c. languages

**c/cpp:** skywalking cpp(github)

https://github.com/SkyAPM/cpp2sky


C++ 1481
C/C++ Header 1081
YAML 372
Markdown 149
Bourne Shell 119
Starlark 81
Python 66
Protocol Buffers 16
SUM 3365


**java:** 官网

https://github.com/apache/skywalking-java


Java 112584
Maven 22589
YAML 21927
Markdown 4783
XML 3895
Windows Module Definition 2641
Bourne Shell 1616
JSON 1436
SQL 212
DOS Batch 147
Kotlin 105
Scala 47
Protocol Buffers 47
make 41
Python 32
Dockerfile 25
JSP 9
SUM 172136


**rust:** 官网

https://github.com/apache/skywalking-rust


Rust 2976
YAML 437
Markdown 269
TOML 92
Python 43
Dockerfile 6
SUM 3823


**golang:** skywalking go(github)

https://github.com/SkyAPM/go2sky


Go 5353
YAML 571
Markdown 313
make 32
Bourne Shell 19
SUM 6288


**python:** 官网

https://github.com/apache/skywalking-python


Python 6331
YAML 4117
Markdown 1128
make 122
TOML 114
Bourne Shell 38
INI 20
JSON 16
Dockerfile 6
SUm 11892


**php:** 官网

https://github.com/apache/skywalking-php


Rust 3282
YAML 1338
PHP 262
Markdown 261
INI 180
TOML 74
XML 65
m4 51
Dockerfile 23
JSON 17
SUM 5553


### Pinpoint

#### a. infrastructure

**network(网卡):** pinpoint network(google/github)

-

**docker:** pinpoint docker(google/github)

-

**envoy:** pinpoint envoy(google/github)

-

**vm:** pinpoint vm(google/github)

-

**gateway:** pinpoint gateway(google/github)

-

#### b. basic services

**CoreDNS:** pinpoint coredns(google/github)

-

**mongoDB:** pinpoint mongodb(google/github)

-

**nginx:** pinpoint nginx(google/github)

https://github.com/pinpoint-apm/pinpoint/tree/62b576a6f0199684ecfda9167fc02455e6e6cb07/agent-plugins/proxy-nginx

**etcd:** pinpoint etcd(google/github)

-

**redis:** github仓库

https://github.com/pinpoint-apm/pinpoint/tree/master/plugins/redis,

https://github.com/pinpoint-apm/pinpoint/tree/master/plugins/redis-lettuce,

https://github.com/pinpoint-apm/pinpoint/tree/master/plugins/redis-redisson

**mysql:** github仓库

https://github.com/pinpoint-apm/pinpoint/tree/master/plugins/mysql-jdbc

#### c. languages

**c/cpp:** 官网

https://github.com/pinpoint-apm/pinpoint-c-agent


C++ 7252
Go 6509
Python 2353
C/C++ Header 2264
PHP 1671
Markdown 1564
C 768
Protocol Buffers 480
HTML 419
YAML 343
CMake 139
INI 61
JSON 41
Dockerfile 29
m4 25
XML 21
SQL 13
Bourne Shell 2
SUM 23954


**java:** pinpoint java(google/github)

-

**js:** pinpoint js(google)

https://github.com/pinpoint-apm/pinpoint-node-agent


JavaScript 20473
TypeScript 508
JSON 434
Swift 247
Markdown 201
Bourne Shell 131
Java 113
YAML 106
DOS Batch 66
CSS 34
html 27
Gradle 23
SUM 22363


**rust:** pinpoint rust(google/github)

-

**golang:** 官网

https://github.com/pinpoint-apm/pinpoint-go-agent


Go 18781
Markdown 1804
Protocol Buffers 593
YAML 51
JSON 45
Assembly 18
C/C++ Header 11
SUM 21303


**python:** 官网

https://github.com/pinpoint-apm/pinpoint-c-agent

**php:** 官网

https://github.com/pinpoint-apm/pinpoint-c-agent

### Zipkin:

#### a. infrastructure

**network(网卡):** zipkin nic/zipkin network(google, github)

-

**docker:** zipkin for docker/zipkin container network(google), zipkin docker/zipkin container(github)

-

**envoy:** zipkin for envoy/envoy instrumentation(google), envoy instrumentation/instrument(github)

https://github.com/envoy-zipkin/example(不知道是否是想要的结果)

**vm:** zipkin vm network/zipkin vm(google), zipkin vm(github)

-

**gateway:** zipkin gateway(google + github)

-



#### b. basic services

**CoreDNS:** zipkin coredns(google), 

https://coredns.io/plugins/trace/

**mongoDB:** zipkin for mongodb(google)

-(https://gitter.im/openzipkin/zipkin?at=5bd6bbaa64cfc273f941a25d)

https://github.com/opentracing-contrib/java-mongo-driver (?)

**nginx:** zipkin nginx(github)

https://github.com/opentracing-contrib/nginx-opentracing, https://github.com/rnburn/nginx-opentracing

**redis:** zipkin for redis(google)

https://www.npmjs.com/package/zipkin-instrumentation-redis (https://github.com/openzipkin/zipkin-js/tree/master/packages/zipkin-instrumentation-redis), 

**etcd:** zipkin etcd/etcd instrument(github), zipkin etcd(google)

-

**mysql:** instrument mysql(github),

https://github.com/juspay/zipkin-instrumentation-mysql,

https://ceshihao.github.io/2018/11/29/tracing-db-operations/

#### c. languages

https://zipkin.io/pages/tracers_instrumentation.html


**c/cpp:** 官网

https://github.com/flier/zipkin-cpp


C 13483
C/C++ Header 4907
C++ 2606
CMake 1426
Markdown 164
YAML 85
Python 78
Groovy 44
Protocol Buffers 15
Bourne Shell 11
SUM 22819


**java:** 官网

https://github.com/openzipkin/brave


Java 59890
Markdown 4633
Maven 4414
Bourne Shell 346
DOS Batch 147
YAML 91
XML 57
Protocol Buffers 18
SUM 69596


**js:** zipkin js(google)

https://github.com/openzipkin/zipkin-js


JavaScript 8918
Markdown 920
TypeScript 775
JSON 725
YAML 86
Protocol Buffers 19
SUM 11443


**rust:** zipkin rust(github)

https://github.com/flier/rust-zipkin


rust 3351
TOML 107
YAML 34
SUM 3492


**golang:** 官网

https://github.com/openzipkin/zipkin-go


Go 8653
Markdown 91
YAML 77
Protocol Buffers 62
make 21
SUM 8904


**python:** 官网

https://pypi.org/project/py-zipkin/


Python 5714
reStructuredText 222
Markdown 196
YAML 196
INI 94
Protocol Buffers 44
make 29
SUM 6354


**php:** 官网

https://github.com/jcchavezs/zipkin-instrumentation-guzzle


PHP 236
Markdown 44
JSON 39
YAML 37
SUM 356



### Jaeger:

#### a. infrastructure

**network(网卡):** jaeger nic/zipkin network(google, github)

-

**docker:** jaeger docker/jaeger docker tracing(google), jaeger docker(github)

https://github.com/carlosonunez/jaeger-django-docker-tutorial(不知道是否是想要的结果)

**envoy:** jaeger for envoy(google), jaeger envoy(github)

-

**vm:** jaeger vm/jaeger vm tracing(google), jaeger vm(github)

-

**gateway:** jaeger gateway(google + github)

-



#### b. basic services

**CoreDNS:** coredns jaeger/coredns tracing jaeger(google), coredns jaeger(github)

-

**mongoDB:** jaeger mongodb(google)

https://github.com/jaegertracing/jaeger/issues/1149 -> https://github.com/opentracing-contrib/java-mongo-driver

**nginx:** does jaeger support nginx tracing(google)

https://www.alibabacloud.com/help/en/tracing-analysis/latest/use-jaeger-to-perform-tracing-analysis-on-nginx, https://sund5429.medium.com/add-jaeger-tracing-to-nginx-7de1d731ee6e

**redis:** jaeger redis(google), jaeger redis(github)

https://itnext.io/all-hail-tracing-a-go-redis-and-jaeger-tale-7904743d0fd (?)

**etcd:** jaeger etcd/instrument etcd(github)

https://github.com/vrutkovs/okd-otel，https://github.com/sallyom/otel-kubeadm

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