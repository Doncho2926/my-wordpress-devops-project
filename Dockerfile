# Използваме официалния WordPress PHP-FPM образ (php8.2)
FROM wordpress:php8.2-fpm

# Работна директория
WORKDIR /var/www/html

# Инсталираме нужните зависимости и компилираме Imagick, GD, ZIP, OPCACHE и други PHP разширения
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    pkg-config \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libwebp-dev \
    libzip-dev \
    zlib1g-dev \
    imagemagick \
    libmagickwand-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-enable imagick || true \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd mysqli zip opcache fileinfo exif \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Настройваме PHP за производителност
RUN { \
    echo "upload_max_filesize=64M"; \
    echo "post_max_size=64M"; \
    echo "memory_limit=256M"; \
    echo "max_execution_time=120"; \
    echo "max_input_vars=3000"; \
    } > /usr/local/etc/php/conf.d/uploads.ini

# Задаваме права на wp-content (WordPress трябва да може да пише там)
RUN chown -R www-data:www-data /var/www/html

# Експонираме порта за PHP-FPM
EXPOSE 9000

# Стартовата команда (оставяме официалната)
CMD ["php-fpm"]
