# exp6测试L7和Clickhouse的内部流程

## L7

实验中，我们分别在顺序和乱序两种情况下进行3次测试，每次测试串行地获取20000个trace的`/api/datasources/proxy/1/trace/v1/stats/querier/L7FlowTracing`文件，并统计获取文件的时间。在每次测试中，首先通过Grafana API获取trace的列表。如果乱序测试，在获取trace列表后会对其进行shuffle。然后，我们会逐个获取trace的`/api/datasources/proxy/1/trace/v1/stats/querier/L7FlowTracing`文件，并统计获取文件的时间。最后，我们会将每个trace的获取时间写入到`result.json`文件中。

由于L7FlowTracing的请求中需要提供查询窗口时间的起始时间和结束时间。为保证每个trace的起始、终止时间都在查询窗口内，当trace的持续时间超过设定时，查询窗口时间也会相应地增加。为了模拟用户的使用场景，我们使用了常用的15分钟的查询窗口时间，同时每个trace的起始时间与查询窗口的起始时间的差值是0-15分钟之间的随机值。

## Clickhouse

实验中，我们分别在顺序和乱序两种情况下进行3次测试，每次测试串行地获取20000次一定时间范围内的span列表，并统计其query_time字段。实验中，我们模拟用户在Grafana中进行查询的场景。首先，我们通过Grafana API获取所有trace中，第一个trace的起始时间和最后一个trace的结束时间。然后，我们会生成多个时长为15分钟查询时间范围，其起始时间和结束时间都在第一个trace的起始时间和最后一个trace的结束时间之间。在顺序情况下，这些查询时间范围是首尾相连的；在乱序情况下，这些查询时间分布是随机的。得到范围后，逐个获取每个范围对应的span列表（限制最大列表长度为100个span）并统计其query_time字段。最后，我们会将查询时间范围写入到`result.json`文件中。