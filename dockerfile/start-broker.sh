#!/bin/bash

CONFIG_FILE="$ROCKETMQ_HOME/conf/broker.conf"

if [[ $HOSTNAME =~ (.*)-([0-9]+)$ ]]; then
    NAME=${BASH_REMATCH[1]}
    ORD=${BASH_REMATCH[2]}
    BROKER_NAME=broker-$ORD
else
    echo "Fialed to parse name and ordinal of Pod"
    exit 1
fi

cat > ${CONFIG_FILE} <<EOF
#集群名称
brokerClusterName=${BROKER_CLUSTER_NAME}
#broker名称
brokerName=${BROKER_NAME}
#0 表示Master,>0 表示Slave
brokerId=${BROKER_ID}
#broker角色 ASYNC_MASTER为异步主节点，SYNC_MASTER为同步主节点，SLAVE为从节点
brokerRole=${BROKER_ROLE}
#刷新数据到磁盘的方式，ASYNC_FLUSH刷新
flushDiskType=ASYNC_FLUSH
##Broker 对外服务的监听端口
listenPort=10911
#nameserver地址，分号分割
namesrvAddr=${NAME_SRV_ADDR}
#是否允许 Broker 自动创建Topic，建议线下开启，线上关闭
autoCreateTopicEnable=${AUTO_CREATE_TOPIC_ENABLE}
#删除文件时间点，默认凌晨 4点
deleteWhen=4
#文件保留时间，默认 48 小时
fileReservedTime=720
#检测物理文件磁盘空间
diskMaxUsedSpaceRatio=88
waitTimeMillsInSendQueue=5000
EOF

cd $ROCKETMQ_HOME
sh bin/mqbroker -c conf/broker.conf