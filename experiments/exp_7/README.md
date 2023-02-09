# Smart-Encoding Benchmark

## Prerequisites

- protobuf
- golang
- tmpl
- clickhouse
- others

```shell
git clone https://github.com/gogo/protobuf.git ~/go/src/github.com/gogo/protobuf/

sudo apt install -y gogoprotobuf sysstat

sudo service clickhouse-server start
clickhouse-client # or "clickhouse-client --password" if you've set up a password.

# run clickhouse test
./cktest -f config-deepflow.yaml
./cktest -f config-lowcard.yaml
./cktest -f config-string.yaml

pidstat -p $(pidof clickhouse-server) -ru 10
```

```sql
SELECT 
    column,    any(type),
    formatReadableSize(sum(column_data_uncompressed_bytes)) AS `original size`,
    formatReadableSize(sum(column_data_compressed_bytes)) AS `compressed size`,
    sum(rows) 
FROM system.parts_columns WHERE (database = 'benchmark_test') AND (table = 'test_deepflow')  GROUP BY column ORDER BY column ASC;

SELECT
    column,
    any(type),
    formatReadableSize(sum(column_data_uncompressed_bytes)) AS `original size`,
    formatReadableSize(sum(column_data_compressed_bytes)) AS `compressed size`,
    sum(rows)
FROM system.parts_columns WHERE (database = 'benchmark_test') AND (table = 'test_lowcard')  GROUP BY column ORDER BY column ASC;

SELECT
    column,
    any(type),
    formatReadableSize(sum(column_data_uncompressed_bytes)) AS `original size`,
    formatReadableSize(sum(column_data_compressed_bytes)) AS `compressed size`,
    sum(rows)
FROM system.parts_columns WHERE (database = 'benchmark_test') AND (table = 'test_string')  GROUP BY column ORDER BY column ASC;
```

DeepFlow:
begin running: 2023-02-08 14:09:25.248024252 +0000 UTC m=+0.358968651
end running: 2023-02-08 14:17:55.250065252 +0000 UTC m=+510.361009689

LowCard:
begin running: 2023-02-08 14:25:06.275963179 +0000 UTC m=+0.582655806
end running: 2023-02-08 14:33:36.27902439 +0000 UTC m=+510.585717049

String:
begin running: 2023-02-08 14:37:17.941787807 +0000 UTC m=+0.585014610
end running: 2023-02-08 14:45:47.943768306 +0000 UTC m=+510.586995125

result
```bash
(venv) junxianshen@junxiandeMacBook-Air exp_7 % python3 parse.py -t deepflow
11.34 54
1.39 54
46.27 30
(venv) junxianshen@junxiandeMacBook-Air exp_7 % python3 parse.py -t lowcard 
88.34 53
2.97 53
86.81 31
(venv) junxianshen@junxiandeMacBook-Air exp_7 % python3 parse.py -t string  
48.86 54
2.74 54
174.54 31
```