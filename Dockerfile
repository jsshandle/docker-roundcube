FROM alpine:3.4
MAINTAINER Johannes Schramm <js@jss.de>

ENV VERSION 1.2.3
ENV CHECKSUM d7f1d041557639c442691a1e5fa791ab77aa97327a0d328a22e0220f3cb2ca97

ENV PKG roundcubemail-$VERSION-complete.tar.gz
ENV URL https://github.com/roundcube/roundcubemail/releases/download/$VERSION/$PKG

RUN apk --no-cache add \
      nginx \
      php5-dom \
      php5-fpm \
      php5-iconv \
      php5-imap \
      php5-json \
      php5-openssl \
      php5-pdo_sqlite \
      php5-pear \
      php5-sockets \
      php5-zip \
      s6
RUN apk --no-cache add \
      openssl
RUN sed -ie "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/php.ini
RUN wget $URL
RUN echo $CHECKSUM "" $PKG | sha256sum -c -
RUN tar -xvf $PKG -C /var/www
RUN rm $PKG
RUN mv /var/www/roundcubemail-* /var/www/roundcube
RUN mv /var/www/roundcube/config /etc/roundcube
RUN sed -ie 's/\$config\['\''db_dsnw'\''\] = .*/\$config\['\''db_dsnw'\''\] = '\
\''sqlite:\/\/\/\/var\/www\/roundcube\/config\/db.sqlite\?mode=0646'\'';/g' /etc/roundcube/defaults.inc.php
RUN apk --force --purge --rdepends del \
      openssl

ADD /entrypoint.sh /entrypoint.sh
ADD /etc /etc

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80

VOLUME /var/www/roundcube/config
