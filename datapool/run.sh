#!/bin/sh
export BUILD_DIR=`pwd`
nohup java -Dspring.config.additional-location=${BUILD_DIR}/datapool-app.yaml -jar ${BUILD_DIR}/properties/datapool-app-1.0-SNAPSHOT.jar&
nohup java -Dspring.config.additional-location=${BUILD_DIR}/cache-manager-app.yaml -jar ${BUILD_DIR}/properties/cache-manager-app-1.0-SNAPSHOT.jar&
nohup java -Dspring.config.additional-location=${BUILD_DIR}/api-controller-app.yaml -jar ${BUILD_DIR}/properties/api-controller-app.jar&