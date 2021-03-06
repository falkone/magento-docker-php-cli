FROM php:7.2-cli-alpine3.9
ENV PHPIZE_DEPS \
    autoconf \
    cmake \
    file \
    g++ \
    gcc \
    libc-dev \
    pcre-dev \
    make \
    git \
    pkgconf \
    re2c \
    # for GD
    freetype-dev \
    libpng-dev  \
    libjpeg-turbo-dev
    # Install dependencies, addons and php-extension
RUN apk add --update --no-cache \
        mc \
        git \
        bash \
        curl \
        redis \
        ssmtp \
        mysql-client \
        icu-dev \
        curl-dev \
        libxslt-dev \
        libxml2-dev \
        libpng-dev \
        freetype-dev \
        libjpeg-turbo-dev \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure intl --enable-intl \
    && docker-php-ext-configure curl \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-configure soap --enable-soap \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        ctype \
        curl \
        dom \
        gd \
        hash \
        intl \
        mbstring \
        opcache \
        pdo_mysql \
        soap \
        sockets \
        xsl \
        zip \
    && rm -rf /var/cache/apk/*

COPY docker-php-entrypoint /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/docker-php-entrypoint"]
ENTRYPOINT ["docker-php-entrypoint"]

ENV MAGENTO_ROOT /var/www/magento

WORKDIR /var/www/magento

USER root

CMD ["php", "-a"]
