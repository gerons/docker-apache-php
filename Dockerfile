FROM php:8.2-apache

# Instalar dependencias necesarias para las extensiones
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libpq-dev \
    vim \
    libcurl4-openssl-dev

# Configurar e instalar GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Instalar y habilitar las extensiones de PHP
RUN docker-php-ext-install \
    pgsql \
    mysqli \
    pdo \
    pdo_pgsql \
    pdo_mysql \
    curl

# Configurar e instalar las extensiones que requieren pasos adicionales
RUN pecl install redis-5.3.7 \
    && pecl install xdebug-3.2.0

# Habilitar las extensiones de PECL
RUN docker-php-ext-enable \
    redis \
    xdebug

# no copia ningún archivo a la imagen
# los archivos se vincularan desde docker-compose.yml

# Exponer el puerto
EXPOSE 80

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Configurar AllowOverride
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Cambiar upload_max_filesize y también post_max_size (recomendado)
RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/' /usr/local/etc/php/php.ini-development && \
    sed -i 's/post_max_size = 8M/post_max_size = 25M/' /usr/local/etc/php/php.ini-development

# Copiar archivo de configuración de Xdebug
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

COPY start-container.sh /var/www/html/start-container.sh
