FROM shipsun/centos6.8
MAINTAINER shipsun/centos6.8 <543999860@qq.com>
LABEL name="ELK" \
    vendor="shipSun" \
    build-date="2017-06-02"
RUN yum -y install wget unzip libxml2-devel openssl-devel bzip2-devel curl-devel libjpeg-devel libpng-devel libXpm-devel freetype-devel gmp-devel libmcryt-devel libmcrypt-devel mysql-devel  aspell-devel recode-devel icu libicu-devel gcc gcc-c++ pcre pcre-devel zlib-devel

COPY libmcrypt-2.5.7.tar.gz /home
COPY httpd-2.4.25.tar.gz /home
COPY apr-1.5.2.tar.gz /home
COPY apr-util-1.5.4.tar.gz /home
#RUN cd /home && wget -c https://mirrors.tuna.tsinghua.edu.cn/apache/httpd/httpd-2.4.25.tar.gz
#RUN cd /home && wget -c https://mirrors.tuna.tsinghua.edu.cn/apache/apr/apr-1.5.2.tar.gz
#RUN cd /home && wget -c https://mirrors.tuna.tsinghua.edu.cn/apache/apr/apr-util-1.5.4.tar.gz

COPY php-7.1.5.tar.gz /home
COPY redis-3.1.2.tgz /home
#RUN cd /home && wget -c http://cn2.php.net/distributions/php-7.1.5.tar.gz
#RUN cd /home && wget -c http://pecl.php.net/get/redis-3.1.2.tgz

RUN cd /home && wget -c https://github.com/shipSun/apache/archive/master.zip -O apache-master.zip
RUN cd /home && wget -c https://github.com/shipSun/php/archive/master.zip -O php-master.zip

RUN cd /home && tar zxvf apr-1.5.2.tar.gz && cd apr-1.5.2 && ./configure \
--prefix=/usr/local/apr && make && make install && cd /home && rm -rf apr-1.5.2.tar.gz apr-1.5.2
RUN cd /home && tar zxvf apr-util-1.5.4.tar.gz && cd apr-util-1.5.4 && ./configure \
--prefix=/usr/local/apr-uitl \
--with-apr=/usr/local/apr && make && make install && cd /home && rm -rf apr-util-1.5.4.tar.gz apr-util-1.5.4
RUN cd /home && tar zxvf httpd-2.4.25.tar.gz && cd httpd-2.4.25 && ./configure \
--prefix=/usr/local/apache \
--enable-rewrite \
--enable-so \
--enable-headers \
--enable-expires \
--enable-modules=most \
--enable-deflate \
--enable-rewrite=shared \
--enable-deflate=shared \
--enable-expires=shared \
--enable-static-support \
--with-mpm=worker \
--enable-nonportable-atomics=yes \
--with-apr=/usr/local/apr \
--with-apr-util=/usr/local/apr-uitl && make && make install && cd /home && rm -rf httpd-2.4.25.tar.gz httpd-2.4.25

RUN groupadd www
RUN useradd -g www -s /bin/nologin www

RUN cd /home && tar zxvf libmcrypt-2.5.7.tar.gz && cd libmcrypt-2.5.7 && ./configure && make && make install && cd /home && rm -rf libmcrypt-2.5.7 libmcrypt-2.5.7.tar.gz

RUN echo "/usr/local/lib">> /etc/ld.so.conf.d/local.conf
RUN ldconfig -v

RUN cd /home && tar zxvf php-7.1.5.tar.gz && cd php-7.1.5 && ./configure \
--prefix=/usr/local/php7 \
--exec-prefix=/usr/local/php7 \
--bindir=/usr/local/php7/bin \
--sbindir=/usr/local/php7/sbin \
--includedir=/usr/local/php7/include \
--libdir=/usr/local/php7/lib/php \
--mandir=/usr/local/php7/php/man \
--with-config-file-path=/usr/local/php7/etc \
--with-mysql-sock=/usr/local/mysql/mysql.sock \
--with-mcrypt=/usr/include \
--with-mhash \
--with-openssl \
--with-mysqli=shared,mysqlnd \
--with-pdo-mysql=shared,mysqlnd \
--with-gd \
--with-iconv \
--with-zlib \
--enable-zip \
--enable-intl  \
--enable-inline-optimization \
--disable-debug \
--disable-rpath \
--enable-shared \
--enable-xml \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-mbregex \
--enable-mbstring \
--enable-ftp \
--enable-gd-native-ttf \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-soap \
--without-pear \
--with-gettext \
--enable-session \
--with-curl \
--with-jpeg-dir \
--with-freetype-dir \
--enable-opcache \
--enable-fpm \
--with-fpm-user=www \
--with-fpm-group=www \
--without-gdbm \
--disable-fileinfo \
--with-apxs2=/usr/local/apache/bin/apxs && make && make install && cd ext/pdo_mysql && ./configure --with-php-config=/usr/local/php7/bin/php-config --with-pdo-mysql=mysqlnd && make && make install && cd /home && rm -rf php-7.1.5.tar.gz php-7.1.5

RUN cd /home && tar zxvf redis-3.1.2.tgz && cd redis-3.1.2 && /usr/local/php7/bin/phpize && ./configure --with-php-config=/usr/local/php7/bin/php-config && make && make install && cd /home && rm -rf redis-3.1.2 redis-3.1.2.tgz

RUN cd /home && unzip apache-master.zip && cd apache-master && yes | cp -rf conf/ /usr/local/apache/ && cd /home && rm -rf apache-master.zip apache-master
RUN cd /home && unzip php-master.zip && cd php-master && yes | cp -rf php.ini /usr/local/php7/etc/ && cd /home && rm -rf php-master php-master.zip

#RUN cd /home/ && wget https://pypi.python.org/packages/ba/2c/743df41bd6b3298706dfe91b0c7ecdc47f2dc1a3104abeb6e9aa4a45fa5d/ez_setup-0.9.tar.gz
#RUN cd /home/ && wget https://pypi.python.org/packages/88/13/7d560b75334a8e4b4903f537b7e5a1ad9f1a2f1216e2587aaaf91b38c991/setuptools-35.0.2.zip#md5=c368b4970d3ad3eab5afe4ef4dbe2437
#RUN cd /home/ && wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz
#RUN cd /home/ && wget https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz#md5=34eed507548117b2ab523ab14b2f8b55
#RUN cd /home/ && wget https://pypi.python.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz#md5=0214e42d63af850256962b6744c948d9
#RUN cd /home/ && wget https://pypi.python.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz#md5=44c679904082a2133f5566c8a0d3ab42
#RUN cd /home/ && wget https://pypi.python.org/packages/df/e1/765f9abdd57610b1c6251e4853edddcac60f929cf6c9029200887dde0f9e/wincertstore-0.2.zip#md5=ae728f2f007185648d0c7a8679b361e2
#RUN cd /home/ && wget https://pypi.python.org/packages/dd/0e/1e3b58c861d40a9ca2d7ea4ccf47271d4456ae4294c5998ad817bd1b4396/certifi-2017.4.17.tar.gz#md5=db40445044feda1437ce3ccd5fc28a57
#RUN cd /home/ && wget https://pypi.python.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz#md5=53895cdca04ecff80b54128e475b5d3b
COPY ez_setup-0.9.tar.gz /home
COPY Python-2.7.13.tgz /home
COPY six-1.10.0.tar.gz /home
COPY pyparsing-2.2.0.tar.gz /home
COPY appdirs-1.4.3.tar.gz /home
COPY wincertstore-0.2.zip /home
COPY certifi-2017.4.17.tar.gz /home
COPY packaging-16.8.tar.gz /home
COPY setuptools-35.0.2.zip /home

RUN cd /home/ && tar zxvf Python-2.7.13.tar.gz && cd Python-2.7.13 &&  ./configure --prefix=/usr/local/python2.7 && make && make install && cd /home && rm -rf Python-2.7.13.tgz Python-2.7.13
RUN cd /home/ && tar zxvf appdirs-1.4.3.tar.gz && cd appdirs-1.4.3 && /usr/local/python2.7/bin/python2 setup.py install && cd /home && rm -rf appdirs-1.4.3.tar.gz appdirs-1.4.3
RUN cd /home/ && tar zxvf certifi-2017.4.17.tar.gz && cd certifi-2017.4.17 && /usr/local/python2.7/bin/python2 setup.py install && cd /home && rm -rf certifi-2017.4.17.tar.gz certifi-2017.4.17
RUN cd /home/ && tar zxvf pyparsing-2.2.0.tar.gz && cd pyparsing-2.2.0 && /usr/local/python2.7/bin/python2 setup.py install && cd /home && rm -rf pyparsing-2.2.0.tar.gz pyparsing-2.2.0
RUN cd /home/ && tar zxvf six-1.10.0.tar.gz && cd six-1.10.0 && /usr/local/python2.7/bin/python2 setup.py install && cd /home && rm -rf six-1.10.0.tar.gz six-1.10.0
RUN cd /home/ && unzip wincertstore-0.2.zip && cd wincertstore-0.2 && /usr/local/python2.7/bin/python2 setup.py install && cd /home && rm -rf wincertstore-0.2 wincertstore-0.2.zip
RUN cd /home/ && tar zxvf packaging-16.8.tar.gz && cd packaging-16.8 && /usr/local/python2.7/bin/python2 setup.py install && cd /home && rm -rf packaging-16.8.tar.gz packaging-16.8
RUN cd /home/ && unzip setuptools-35.0.2.zip && cd setuptools-35.0.2 && /usr/local/python2.7/bin/python2 setup.py install && cd /home && rm -rf setuptools-35.0.2.zip setuptools-35.0.2
RUN cd /home/ && tar zxvf ez_setup-0.9.tar.gz && cd ez_setup-0.9 && /usr/local/python2.7/bin/python2 setup.py install && cd /home && rm -rf ez_setup-0.9.tar.gz ez_setup-0.9
RUN /usr/local/python2.7/bin/easy_install pip
RUN /usr/local/python2.7/bin/pip install supervisor
RUN /usr/local/python2.7/bin/echo_supervisord_conf > /etc/supervisord.conf


