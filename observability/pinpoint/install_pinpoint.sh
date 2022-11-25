#!/bin/sh

pushd .

cd ~

# Create HBase schemas

wget https://raw.githubusercontent.com/pinpoint-apm/pinpoint/master/hbase/scripts/hbase-create.hbase

$HBASE_HOME/bin/hbase shell hbase-create.hbase

rm hbase-create.hbase

# Install Pinpoint Collector

wget https://github.com/pinpoint-apm/pinpoint/releases/download/v2.4.2/pinpoint-collector-boot-2.4.2.jar

java -jar -Dpinpoint.zookeeper.address=localhost pinpoint-collector-boot-2.4.2.jar

# Install Pinpoint Web

wget https://github.com/pinpoint-apm/pinpoint/releases/download/v2.4.2/pinpoint-web-boot-2.4.2.jar

java -jar -Dpinpoint.zookeeper.address=localhost pinpoint-web-boot-2.4.2.jar

# Install Pinpoint Agent

wget https://github.com/pinpoint-apm/pinpoint/releases/download/v2.4.2/pinpoint-agent-2.4.2.tar.gz

tar xzf pinpoint-agent-2.4.2.tar.gz

rm pinpoint-agent-2.4.2.tar.gz

export AGENT_PATH=~/pinpoint-agent-2.4.2

echo "Pinpoint is installed."

popd