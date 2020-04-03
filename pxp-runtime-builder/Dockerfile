#POLYSCRIPT
FROM polyverse/php-polyscripting-builder:1b5fb0089973c9db7f4071cb41b2f71731a6f6b3 as polyscripter

# Build PHP in the Lambda container
FROM amazonlinux:2017.03.1.20170812 as builder
ARG php_version="7.2.0"

RUN echo $MODE
RUN sed -i 's;^releasever.*;releasever=2017.03;;' /etc/yum.conf && \
    yum clean all && \
    yum install -y autoconf \
                bison \
                gcc \
                gcc-c++ \
                make \
                libcurl-devel \
                libxml2-devel \
                openssl-devel \
                bzip2-devel \
                tar \
                gzip \
		vim \
		re2c \
                zip \
                unzip \
                git

###<POLYSCRIPT DEPS>###
COPY --from=polyscripter /polyscripting /polyscript-src
COPY --from=polyscripter /lambda /polyscript-src
ENV POLYSCRIPT_PATH "/polyscript-src"
ENV PHP_SRC_PATH "/php-src-php-${php_version}"
ENV PHP_EXEC "/runtime/bin"
###</POLYSCRIPT DEPS>###

RUN curl -sL https://github.com/php/php-src/archive/php-${php_version}.tar.gz | tar -xvz && \
    cd php-src-php-${php_version} && \
    ./buildconf --force && \
    ./configure --prefix=/opt/php/ --with-openssl --with-curl --with-zlib --without-pear --enable-bcmath --with-bz2 --enable-mbstring && \
    make install 

RUN mkdir -p /runtime/bin && \
    cp /opt/php/bin/php /runtime/bin/php

COPY src/* /runtime/

ARG MODE
ENV MODE ${MODE}
WORKDIR $POLYSCRIPT_PATH

ARG CACHEBUST
RUN if [ "$MODE" == "polyscripted" ] ; then ./build-scrambled.sh  ; else echo "Polyscripting disabled" ; fi

RUN cp /opt/php/bin/php /runtime/bin/php
