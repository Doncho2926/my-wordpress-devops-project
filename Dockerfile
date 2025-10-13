# Използваме официалния WordPress PHP-FPM образ (php8.2)
FROM wordpress:php8.2-fpm

# Работна директория
WORKDIR /var/www/html

# Инсталираме нужните зависимости и компилираме Imagick
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        pkg-config \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libwebp-dev \
        libzip-dev \
        imagemagick \
        libmagickwand-dev \
        zip \
        unzip \
        git \
    && docker-php-ext-enable imagick || true \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd mysqli zip opcache fileinfo exif \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ✅ Копираме персонализирания php.ini (от корена на проекта)
COPY php.ini /usr/local/etc/php/conf.d/zz-uploads.ini

# ✅ Създаваме uploads директория и даваме права
RUN mkdir -p /var/www/html/wp-content/uploads \
    && chown -R www-data:www-data /var/www/html/wp-content \
    && chmod -R 775 /var/www/html/wp-content

# ✅ Настройки за WordPress
ENV WORDPRESS_DEBUG=1

EXPOSE 9000

CMD ["php-fpm"]
