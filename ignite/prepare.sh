IGNITE_BIN=`pwd`
wget https://archive.apache.org/dist/ignite/2.14.0/apache-ignite-2.14.0-bin.zip
unzip ${IGNITE_BIN}/apache-ignite-2.14.0-bin.zip -d ${IGNITE_BIN}
unzip ${IGNITE_BIN}/libs.zip -d ${IGNITE_BIN}
export IGNITE_HOME=${IGNITE_BIN}/apache-ignite-2.14.0-bin
cp ${IGNITE_BIN}/libs/* ${IGNITE_HOME}/libs
chmod -R 777 ${IGNITE_HOME}/libs
export USER_LIBS=${IGNITE_HOME}/libs/ignite-prometheus-1.0-SNAPSHOT-jar-with-dependencies.jar
bash ${IGNITE_HOME}/bin/ignite.sh ${IGNITE_BIN}/config/datapool-server.xml