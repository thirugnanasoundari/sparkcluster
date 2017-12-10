#!/bin/bash
publicDns=""
masterIp=""

set -x

#!/bin/bash

for i in "$@"
do
case $i in
    -d=*|--dns=*)
    publicDns="${i#*=}"
    shift # past argument=value
    ;;
    -m=*|--masterIp=*)
    masterIp="${i#*=}"
    shift # past argument=value
    ;;
    *)
          # unknown option
          echo "usage: -d=127.0.0.1 -m=53.63.73.73 "
          exit 1
    ;;
esac
done



if [[ $publicDns == "" ]]; then
	echo "publicDns -d should be passed. This ip is used by spark web UI. Else it uses private ip in creating links."
	exit 1
fi

if [[ $masterIp == "" ]]; then
	echo "masterIp  -s not passed. Master ip is required to connect to master"
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
echo "export SPARK_PUBLIC_DNS=$publicDns" >> ~ec2-user/.bash_profile

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

sudo -u ec2-user SPARK_PUBLIC_DNS=$publicDns $SPARK_HOME/sbin/start-slave.sh spark://$masterIp:7077