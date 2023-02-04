在worker中收集数据
首先，在 worker.rs 中的 collect_data() 函数中，向 worker 进程发送请求，获取需要收集的数据；然后，在 sender 文件夹中的 send_data() 函数中，将获取到的数据发送到目标。

发送数据到server
在 deepflow/agent/src/main.rs 文件中的 main 函数中，会调用 start_agent 函数。
在 start_agent 函数中，会调用 start_sender 函数，该函数会启动一个单独的线程，负责将数据发送给 server。
在 start_sender 函数中，会调用 Sender::run 函数。
Sender 结构体中实现了一个 run 方法，该方法会不断从一个队列中取出数据，并使用网络传输协议将数据发送给 server。
具体来说，Sender 结构体中有一个 session 字段，该字段是一个 Session 结构体的实例，Session 结构体中有多个方法可以用于网络通信。
在 Sender::run 方法中，会不断调用 Session 中的 push 方法，将数据发送给 server。
具体的，Sender::run 方法中会不断调用 session.push(data) 方法，将数据发送给 server。
Sender::run 方法中会不断调用 session.push(data) 方法，将数据发送给 server。

collector：
处理网络流量信息。它接收来自采集器的流量信息，然后进行一些初步的处理，例如计算流量统计信息、记录流的状态、以及处理 NAT 后的流信息等。最后，它会将处理后的流量信息打包发送到目标接收器。
当 Collector 类接收到来自采集器的流量信息时，它会进行如下初步处理：
计算流量的统计信息，例如流的速率、包的数量等。
根据流的状态信息（例如是否是新流、是否已经结束），记录流的状态。
处理 NAT 后的流信息，例如修改源 IP 地址等。
collector会把收集好，初步处理过的网络信息存入hashmap中，供其他模块调用。

定义指标数据的结构体，如 MetricData、CounterData、GaugeData等，用于存储收集的数据。
定义不同类型的指标，如 Counter、Gauge、Histogram等，并提供了相应的方法用于更新指标数据。
提供了Collector接口，定义了收集器的基本功能，如初始化、获取当前收集的数据、清空当前数据等。
实现了收集器的各种具体实现，如PrometheusExporter、MetricWriter等，用于向具体的数据存储目标收集数据。
将collector文件夹中的代码理解为是一个收集器。它的作用是从多个源（包括本地的文件、系统的性能数据以及远程的机器）收集数据并转化为所需的格式。


dispatcher：
在hashmap中进一步读取流量信息，并进行分析（删除重复数据，并根据包的类型不同进行分发）
分为三个模式：分析器模式，基础模式和镜像模式
TODO：三种模式的异同？

metric：
网络信息测量器，提供网络流量信息。
允许测量器进行合并和翻转。
TODO：翻转的操作在整体运行中有什么作用？

rpc：
定义了一个结构体 NtpPacket，用于表示网络时间协议（NTP）版本3 / 4数据包。它还包含了一些方法用于操作和转换这个数据包。
TODO 其他几个文件的阅读

sender：
sender文件夹中包含了向网络中发送数据的代码。
它包括了发送不同协议的数据包的代码，例如发送VXLAN、ERSPAN、IPV4、IPV6等协议的数据包。
sender文件夹中还包括了辅助发送数据的工具，例如用于序列化数据包的代码，用于获取网络接口信息的代码，用于解析网络地址的代码等。



