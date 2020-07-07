## rocketmq在k8s中部署
nameserver无状态，使用deployment部署
broker使用statefulset部署
传入mq相关环境变量，通过start-broker.sh脚本写入配置文件

数据持久化只考虑了测试环境



写部署脚本