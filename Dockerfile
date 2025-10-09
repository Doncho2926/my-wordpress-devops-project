# Използваме официалния WordPress PHP-FPM образ
FROM wordpress:php8.2-fpm

# Работна директория
WORKDIR /var/www/html

# Инсталираме нужните зависимости и PHP разширения (включително Imagick)
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        pkg-config \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libwebp-dev \
        libzip-dev \
        zip \
        unzip \
        imagemagick \
        libmagickwand-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd mysqli zip opcache fileinfo exif \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ✅ Копираме персонализирания php.ini (от корена на проекта)
COPY php.ini /usr/local/etc/php/conf.d/zz-uploads.ini

# ✅ Уверяваме се, че WordPress може да записва uploads
RUN mkdir -p /var/www/html/wp-content/uploads \
    && chown -R www-data:www-data /var/www/html/wp-content \
    && chmod -R 775 /var/www/html/wp-content

# ✅ Настройки за WordPress
ENV WORDPRESS_DEBUG=1

# ✅ Даваме права на www-data върху целия WordPress
RUN chown -R www-data:www-data /var/www/html

# Експонираме порта на PHP-FPM
EXPOSE 9000

# ✅ CMD трябва да е последен
CMD ["php-fpm"]
