MAINTAINER shipsun/centos6.8 <543999860@qq.com>
LABEL name="ELK" \
    vendor="shipSun" \
    build-date="2017-06-02"
RUN yum -y install wget unzip libxml2-devel openssl-devel bzip2-devel curl-devel libjpeg-devel libpng-devel libXpm-devel freetype-devel gmp-devel libmcrypt-devel mysql-devel aspell-devel recode-devel icu libicu-devel gcc gcc-c++pcre prce-devel zlib-devel

RUN cd /home && wget -c https://mirrors.tuna.tsinghua.edu.cn/apache/httpd/httpd-2.4.25.tar.gz
RUN cd /home && wget -c https://mirrors.tuna.tsinghua.edu.cn/apache/apr/apr-1.5.2.tar.gz
RUN cd /home && wget -c https://mirrors.tuna.tsinghua.edu.cn/apache/apr/apr-util-1.5.4.tar.gz
RUN cd /home && wget -c http://cn2.php.net/distributions/php-7.1.5.tar.gz
RUN cd /home && wget -c http://pecl.php.net/get/redis-3.1.2.tgz
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


