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

**java:** 官网

https://github.com/openzipkin/brave, https://github.com/openzipkin/zipkin-js

**js:** zipkin js(google)

https://github.com/openzipkin/zipkin-js

**rust:** zipkin rust(github)

https://github.com/flier/rust-zipkin

**golang:** 官网

https://github.com/openzipkin/zipkin-go

**python:** 官网

https://pypi.org/project/py-zipkin/

**php:** 官网

https://github.com/jcchavezs/zipkin-instrumentation-guzzle





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

**java:** 官网

https://github.com/jaegertracing/jaeger-client-java

**js:** 官网

https://github.com/jaegertracing/jaeger-client-node

**rust:** jaeger rust(github)

https://github.com/open-telemetry/opentelemetry-rust, https://github.com/sile/rustracing_jaeger

**golang:** 官网

https://github.com/jaegertracing/jaeger-client-go

**python:** 官网

https://github.com/jaegertracing/jaeger-client-python

**php:** jaeger php(github)

https://github.com/code-tool/jaeger-client-php, https://github.com/jonahgeorge/jaeger-client-php