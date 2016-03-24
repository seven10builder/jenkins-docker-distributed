#!/bin/bash
if [[ -z $MASTER_ADDRESS ]]; then
	echo "The jenkins master address must be specified in the variable MASTER_ADDRESS"
	exit 1
fi
SLAVE_PATH=/home/jenkins/bin

mkdir -p $SLAVE_PATH
wget -O $SLAVE_PATH/slave.jar http://$MASTER_ADDRESS/jnlpJars/slave.jar
java -jar $SLAVE_PATH/slave.jar