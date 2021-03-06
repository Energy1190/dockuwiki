FROM debian

RUN apt-get update -y \
    && apt-get install -y wget perl lighttpd php-cgi php-gd php-ldap php-curl \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O /dokuwiki.tgz https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz \
    && mkdir /app \
    && tar -zxf dokuwiki.tgz -C /app --strip-components 1 \
    && rm -f /dokuwiki.tgz

RUN chown -R www-data:www-data /app && mkdir /data

ADD dokuwiki.conf /etc/lighttpd/conf-available/20-dokuwiki.conf
ADD start.sh /start.sh

RUN lighty-enable-mod dokuwiki fastcgi accesslog
RUN mkdir /var/run/lighttpd && chown -R www-data:www-data /var/run/lighttpd
RUN chmod +x /start.sh

EXPOSE 80

ENTRYPOINT ["/start.sh"]
