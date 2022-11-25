#!/bin/sh

if [ -z "$JAVA_HOME" ]; then
    echo "JAVA_HOME is not set"
    exit 1
fi

cd ~

. ~/hbase-2.5.1/bin/stop-hbase.sh

rm -rf ~/hbase-2.5.1/