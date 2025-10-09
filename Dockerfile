# Използваме официалния WordPress PHP-FPM образ
FROM wordpress:php8.2-fpm

WORKDIR /var/www/html

# Инсталираме нужните зависимости и Imagick без компилация
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        pkg-config \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libwebp-dev \
        libzip-dev \
        imagemagick \
        php-imagick \
        zip \
        unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd mysqli zip opcache fileinfo exif \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY php.ini /usr/local/etc/php/conf.d/zz-uploads.ini

RUN mkdir -p /var/www/html/wp-content/uploads \
    && chown -R www-data:www-data /var/www/html/wp-content \
    && chmod -R 775 /var/www/html/wp-content

ENV WORDPRESS_DEBUG=1

EXPOSE 9000

CMD ["php-fpm"]
