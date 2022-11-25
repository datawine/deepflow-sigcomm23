#!/bin/sh

pushd .

cd ~

# Remove Pinpoint Agent

rm -rf ~/pinpoint-agent-2.4.2

# Remove Pinpoint Web

rm pinpoint-web-boot-2.4.2.jar

# Remove Pinpoint Collector

rm pinpoint-collector-boot-2.4.2.jar

# Remove HBase schemas

if [ -z "$JAVA_HOME" ]; then
    echo "JAVA_HOME is not set"
    exit 1
fi

wget https://raw.githubusercontent.com/pinpoint-apm/pinpoint/master/hbase/scripts/hbase-drop.hbase

$HBASE_HOME/bin/hbase shell hbase-drop.hbase

rm hbase-drop.hbase

echo "Pinpoint is uninstalled."

popd > /dev/null