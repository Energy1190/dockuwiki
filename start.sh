#!/bin/bash

start_app (){
lighty-enable-mod dokuwiki fastcgi accesslog
exec /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf
}

if [ `ls /data | wc -l` -eq 0 ]; then 
start_app
else
for obj in $(ls /data); do
echo "Work with ${obj}"
rm -rf /app/${obj}
ln -s /data/${obj} /app/${obj}
done
chown -R www-data:www-data /data
start_app
fi
