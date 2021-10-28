#!/bin/bash
#amazon-linux-extras install -y epel
yum -y install git lynx w3m lsof certbot wget
yum -y update
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip"
unzip awscliv2.zip
aws/install

H=home/ec2-user
C=/home/centos
R=root

cd /tmp
wget https://nachashin.github.io/ec2_init/ec2_init.tgz
tar xvfz ec2_init.tgz
cat $H/.ssh/authorized_keys >> $C/.ssh/authorized_keys
cat $H/.bashrc >> $C/.bashrc
for f in .inputrc .exrc .vimrc .bash_aliases
do
    cp $H/$f $C
done
chown -R centos:centos $C
chmod 700 $C/.ssh
chmod 600 $C/.ssh/authorized_keys

cat $R/.bashrc >> /$R/.bashrc
for f in .inputrc .exrc .vimrc .screenrc .dir_colors .bash_aliases 
do
    cp $R/$f /$R
done

cp usr/local/bin/ip.sh /usr/local/bin

for d in $H $R usr
do
    rm -rf $d
done
