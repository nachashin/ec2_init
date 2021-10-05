#!/bin/bash
amazon-linux-extras install -y epel
yum -y install git lynx w3m certbot wget
yum -y update

# individual setting
H=home/ec2-user
cd /tmp
wget https://nachashin.github.io/ec2_init.tgz
tar xvfz ec2_init.tgz
sleep 30
cat $H/.ssh/authorized_keys >> /$H/.ssh/authorized_keys
cat $H/.bashrc >> /$H/.bashrc
for f in .inputrc .exrc .vimrc .bash_aliases
do
    cp $H/$f /$H
done
chown -R ec2-user:ec2-user /$H
chmod 700 /$H/.ssh
chmod 600 /$H/.ssh/authorized_keys

R=root
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


