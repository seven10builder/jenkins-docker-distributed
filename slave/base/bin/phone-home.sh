#!/bin/bash
if [[ -z $1 ]]; then
	echo "Usage: phone-home.sh <master-ip-address>"
	exit 1
fi
MASTER_ADDRESS="$1"
SLAVE_PATH=/home/jenkins/bin

mkdir -p $SLAVE_PATH
wget -O $SLAVE_PATH/slave.jar http://$MASTER_ADDRESS/jnlpJars/slave.jar
java -jar $SLAVE_PATH/slave.jar