#!/bin/bash

machineType="$1"
masterIp="$2"
slaveIp="$3"

if [[ $machineType == "" ]]; then
	echo "machineType should be passed. It was empty"
	exit 1
fi

if [[ $machineType == "master" && $masterIp == "" ]]; then
	echo "masterip should be passed to listen on"
	exit 1
fi

if [[ $machineType == "slave" && $masterIp == "" ]]; then
	echo "masterip should be passed for a slave machine"
	exit 1
fi

if [[ $machineType == "slave" && $slaveIp == "" ]]; then
	echo "slaveIp should be passed for a slave machine to listen on"
	exit 1
fi

if [[ $machineType != "master" && $machineType != "slave" ]]; then
	echo "usage $0 master|slave [masterip]"
	exit 1
fi

#update
sudo yum update -y

# Download Spark to the ec2-user's home directory
cd ~
wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz
 
# Unpack Spark in the /opt directory
sudo tar zxvf spark-2.2.0-bin-hadoop2.7.tgz -C /opt
 
# Create a symbolic link to make it easier to access
sudo ln -fs spark-2.2.0-bin-hadoop2.7 /opt/spark

# Insert these lines into your ~/.bash_profile:
echo 'export SPARK_HOME=/opt/spark' >> ~ec2-user/.bash_profile
echo 'PATH=$PATH:$SPARK_HOME/bin' >> ~ec2-user/.bash_profile
echo 'export SPARK_LOCAL_IP=127.0.0.1' >> ~ec2-user/.bash_profile
if [[ $machineType == "master" ]]; then
	
	echo "export SPARK_PUBLIC_DNS=$masterIp" >> ~ec2-user/.bash_profile
elif [[ $machineType  == "slave" ]]; then
	echo "export SPARK_PUBLIC_DNS=$slaveIp" >> ~ec2-user/.bash_profile
else
	echo "Error. Machine Type can be master or slave"
	exit 1
fi	

echo 'export PATH' >> ~ec2-user/.bash_profile

# Reload environment variables
source ~ec2-user/.bash_profile
 

#install java
yum install java-1.8.0-openjdk -y

#change java version
alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java

# Confirm that spark-submit is now in the PATH.
spark-submit --version
# (Should display a version number)

if [[ $machineType == "master" ]]; then

	sudo -u ec2-user SPARK_PUBLIC_DNS=$masterIp $SPARK_HOME/sbin/start-master.sh 
elif [[ $machineType  == "slave" ]]; then
	sudo -u ec2-user SPARK_PUBLIC_DNS=$slaveIp $SPARK_HOME/sbin/start-slave.sh spark://$masterIp:7077
else
	echo "Error. Machine Type can be master or slave"
	exit 1
fi	
	#statements

#sudo ./boot.sh master  54.236.164.152 54.236.164.152