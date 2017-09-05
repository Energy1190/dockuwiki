FROM debian

RUN apt-getupdate -y \
    && apt-get install -y wget lighttpd php5-cgi php5-gd php5-ldap php5-curl \
	&& rm -rf /var/lib/apt/lists/*

RUN wget -g -O /dokuwiki.tgz https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz \
    && mkdir /app \
	&& tar -zxf dokuwiki.tgz -C /app --strip-components 1 \
	&& rm -f /dokuwiki.tgz

RUN chown www-data:www-data /app

ADD dokuwiki.conf /etc/lighttpd/conf-available/20-dokuwiki.conf
RUN lighty-enable-mod dokuwiki fastcgi accesslog
RUN mkdir /var/run/lighttpd && chown www-data.www-data /var/run/lighttpd

EXPOSE 80
VOLUME ["/app/data/","/app/lib/plugins/","/app/conf/","/app/lib/tpl/","/var/log/"]

CMD ["/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]