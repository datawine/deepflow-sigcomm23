#!/bin/sh

if [ -z "$JAVA_HOME" ]; then
    echo "JAVA_HOME is not set"
    exit 1
fi

cd ~

wget https://dlcdn.apache.org/hbase/2.5.1/hbase-2.5.1-bin.tar.gz -O hbase.tar.gz

mkdir -p hbase

tar -xzf hbase.tar.gz --directory hbase

rm hbase.tar.gz

. hbase/bin/start-hbase.sh