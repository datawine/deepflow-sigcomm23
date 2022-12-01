#!/bin/sh

pushd .

cd ~

# Set up HBase cluster

if [ -z "$JAVA_HOME" ]; then
    echo "JAVA_HOME is not set!"
    exit 1
fi

wget https://dlcdn.apache.org/hbase/2.5.1/hbase-2.5.1-bin.tar.gz

tar -xzf hbase-2.5.1-bin.tar.gz

rm hbase-2.5.1-bin.tar.gz

. hbase-2.5.1/bin/start-hbase.sh

echo "HBase is installed."

popd > /dev/null