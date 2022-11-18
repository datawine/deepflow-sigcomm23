#!/bin/sh

wget https://dlcdn.apache.org/hbase/2.5.1/hbase-2.5.1-bin.tar.gz

tar xzvf hbase-2.5.1-bin.tar.gz

mv hbase-2.5.1 ~



if [ -z "$JAVA_HOME"]; then
    echo "JAVA_HOME is not set"
    exit 1
fi

. ~/hbase-2.5.1/bin/start-hbase.sh