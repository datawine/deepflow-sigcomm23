#!/bin/sh

pushd .

cd ~

####################################################

# Uninstall HBase

if [ -z "$JAVA_HOME" ]; then
    echo "JAVA_HOME is not set"
    exit 1
fi

. ~/hbase-2.5.1/bin/stop-hbase.sh

rm -rf ~/hbase-2.5.1/

rm -rf ~/tmp/

####################################################

echo "Pinpoint is uninstalled."

popd > /dev/null