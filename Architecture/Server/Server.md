#**Deepflow Server部分代码架构**

- [controller](#controller)
  - [controllermaster](#controllermaster)
  - [controller](#controller)
    - [router,service](#router,service)
    - [manager](#manager)
    - [synchronizer](#synchronizer)
    - [recorder](#recorder)
    - [tagrecorder](#tagrecorder)
    - [cloud](#cloud)
- [querier](#querier)
  - [engine](#engine)
  - [parse](#parse)
- [ingester](#ingester)

#### controller

支持各主流云/容器平台的资源抽象与对接

支持发送Meta资源给deepflow-ingester，用于观测数据进行Tag标记

支持管理10w量级deepflow-agent，可以做到单元化部署、多Region统一管理

##### controllermaster

对外提供API: 云平台相关API, 控制器/数据节点/采集器相关API

健康检查

授权检查

##### controller

###### router,service

对外提供API

###### manager

负责各云平台task的更新和生命周期管理，task包括cloud（云平台信息收集和组装）和record（数据库记录）

###### synchronizer

推送平台/采集器配置数据

控制器/数据节点/采集器自动发现

###### recorder

记录资源数据

发送资源变更事件

###### tagrecorder

记录字典标签数据

###### cloud

各类云平台的收集和组装

kubernetes_gather:由各云平台按需启动，向其（包括kubernetes）提供K8s资源数据（不考虑云平台业务逻辑）

#### querier

提供一种面向Metrics、Tracing、Logging、Event的统一查询语言，打通各类观测数据。

##### engine

DB目录 定义DBEngine结构，实现sql的translate

TODO：client目录 获取连接及执行语句

engine.go 定义Engine接口，所有db的Engine结构体需实现该接口

##### parse

parse.go 定义了Parser结构体，用于sql解析

#### ingester

与deepflow-agent之间使用高性能私有协议，支持观测数据的快速传输和批量写入，避免依赖额外的消息队列。

支持对观测数据进行Tag增强，卸载deepflow-agent的本地计算压力和传输压力。
