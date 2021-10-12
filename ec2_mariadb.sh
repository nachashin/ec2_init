#!/bin/bash
amazon-linux-extras install -y mariadb10.5
systemctl enable mariadb
systemctl start mariadb

NEWPASS_ROOT=`cat /dev/urandom | tr -dc '[:alnum:]' | head -c 16`
NEWPASS_WEB=`cat /dev/urandom | tr -dc '[:alnum:]' | head -c 16`
WEBDBUSER=webdbuser
WEBDB=webdb

LOCALIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
LOCALNET=`echo $LOCALIP | sed -e 's/^\([0-9]*\)\.\([0-9]*\)\.[0-9]*\.[0-9]*$/\1.\2.0.0/g'`

sed -i -e "s/P@ssw0rd123/${NEWPASS_ROOT}/g" /root/.bash_aliases
echo "alias myweb=\"mysql -u web -p'${NEWPASS_WEB}' ${WEBDBUSER}\"" >> /root/.bash_aliases

cat << EOS > /etc/my.cnf.d/custom.cnf
[mysqld]
aracter-set-server=utf8mb4
skip-character-set-client-handshake
default-storage-engine=InnoDB

[mysql]
default-character-set=utf8mb4

[mysqldump]
default-character-set=utf8mb4
EOS

mysql -u root --password= -e "
    UPDATE mysql.user SET Password=PASSWORD('${NEWPASS_ROOT}') WHERE User='root';
    DELETE FROM mysql.user WHERE User='';
    DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
    DROP DATABASE test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    CREATE DATABASE IF NOT EXISTS ${WEBDB} DEFAULT CHARACTER SET utf8mb4;
    CREATE USER IF NOT EXISTS ${WEBDBUSER}@localhost IDENTIFIED BY '${NEWPASS_WEB}';
    CREATE USER IF NOT EXISTS ${WEBDBUSER}@${LOCALNET} IDENTIFIED BY '${NEWPASS_WEB}';
    GRANT ALL ON ${WEBDB}.* TO ${WEBDBUSER}@localhost;
    GRANT ALL ON ${WEBDB}.* TO ${WEBDBUSER}@${LOCALNET};
    FLUSH PRIVILEGES;"
