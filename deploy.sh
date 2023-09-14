#! /bin/bash

## 修改启动端口号SERVER_PORT、运行jar包所在目录APP_HOME、jar包名称RUN_JAR
SERVER_PORT=8100
RUN_JAR="risun-rsp.jar"
APP_HOME="/home/risun-app/rsp"
APP_NAME="${APP_HOME}/${RUN_JAR}"
LOG_HOME="${APP_HOME}/logs"
UPLOAD_PATH="${APP_HOME}/files"
APIKEY_PATH="${APP_HOME}/apikey"
HEALTH_CHECK="health_check"

JAVA_OPTS="-Xmn256m -Xms1024m -Xmx1024m -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=256m"

# 使用说明，用来提示输入参数
usage() {
    echo "Usage: ./run.sh [start|stop|restart|status]"
    exit 1
}

#检查程序是否在运行
is_exist() {
    pid=`ps -ef | grep ${RUN_JAR} | grep -v grep | awk '{print $2}' `
    #pid=`jps | grep ${RUN_JAR} | awk '{print $1}'`
    #如果不存在返回1，存在返回0
    if [ -z "${pid}" ]; then
      return 1
    else
      return 0
    fi
}

#启动方法
start() {
   is_exist
   if [ $? -eq "0" ]; then
     echo "${APP_NAME} is already running. listening to ${SERVER_PORT}. pid=${pid}."
   else
     echo "${APP_NAME} begin to start, listening to ${SERVER_PORT}"
     nohup java $JAVA_OPTS \
     	-Dfile.encoding=utf-8 \
     	-Djava.security.egd=file:/dev/./urandom \
		-jar $APP_NAME \
		--risun.profile=${UPLOAD_PATH} \
        --risun.apiKey=${APIKEY_PATH} \
     	--server.port=${SERVER_PORT} \
		--spring.redis.host="127.0.0.1" \
	    --spring.redis.port=6379 \
		--spring.redis.database=0 \
        --spring.redis.password=123456 \
        --spring.datasource.druid.master.url="jdbc:postgresql://127.0.0.1:5432/testdb?currentSchema=public&useUnicode=true&characterEncoding=UTF-8" \
		--spring.datasource.druid.master.username="testuser" \
		--spring.datasource.druid.master.password="Nxltxcy_123" > /dev/null 2>&1 &
   fi
}

#停止方法
stop() {
   is_exist
   if [ $? -eq "0" ]; then
     kill -9 $pid
   else
     echo "${APP_NAME} is not running"
   fi
}

#输出运行状态
status() {
   is_exist
   if [ $? -eq "0" ]; then
     echo "${APP_NAME} is running. Listening to ${SERVER_PORT}. Pid is ${pid}"
   else
     echo "${APP_NAME} is not running."
   fi
}

#重启
restart() {
   stop
   start
}

#健康检查
healthCheck() {
    sleep 2
    SIGNAL=0
    while [ $SIGNAL != 1 ]; do
        RESULT=`curl -I -m 10 -o /dev/null -s -w %{http_code} http://localhost:${SERVER_PORT}/${HEALTH_CHECK}`
        if [ $RESULT = 200 ]; then
            SIGNAL=1
            tail -n 10 ${LOG_HOME}/sys-error.log
        else
            tail -n 20 ${LOG_HOME}/sys-error.log
            sleep 5
        fi
    done
}

#根据输入参数，选择执行对应方法，不输入则执行使用说明
case "$1" in
   "start")
     start
     ;;
   "stop")
     stop
     ;;
   "status")
     status
     ;;
   "restart")
     restart
     ;;
   "healthCheck")
     healthCheck
     ;;
   *)
     usage
     ;;
esac
