#!/bin/bash
LANG=C
NOW=`date "+%Y%m%d%H%M%S"`
TMP=/tmp/ip$NOW.txt
echo '*** intranet ***'
#/sbin/ifconfig | grep 'inet addr' | cut -b 21-40 | cut -d' ' -f 1
/sbin/ip addr | grep '^    inet ' | cut -f 1 -d'/' | sed 's/    inet //g'

wget -O $TMP http://checkip.dyndns.org > /dev/null 2>&1
#wget -O $TMP http://www.itrev.info/ip.php?pw=12345678 > /dev/null 2>&1
#curl ifconfig.io
if [ -e $TMP ]; then
	sed -e 's/\(^.*Address: \)\([0-9.]*\)\(.*$\)/\2/g' -i $TMP
	echo '*** internet ***'
	cat $TMP
	rm -f $TMP
fi
