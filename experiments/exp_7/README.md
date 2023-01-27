# Smart-Encoding Benchmark

## Prerequisites

- protobuf
- golang
- tmpl
- clickhouse
- others

```shell
git clone https://github.com/gogo/protobuf.git ~/go/src/github.com/gogo/protobuf/

sudo apt install gogoprotobuf

sudo service clickhouse-server start
clickhouse-client # or "clickhouse-client --password" if you've set up a password.
```