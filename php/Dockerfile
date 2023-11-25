FROM php:8.2.8-fpm
USER root
# Устанавливаем рабочую директорию
WORKDIR /var/www


# Устанавливаем зависимости
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libpq-dev \
    libonig-dev \
    libzip-dev

# Очищаем кэш
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Устанавливаем расширения PHP
RUN docker-php-ext-install pdo_mysql mysqli mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd


# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Создаём пользователя и группу www для приложения Laravel
RUN if [ ! $(getent group www) ]; then groupadd -g 1000 www; fi
RUN if [ ! $(getent passwd www) ]; then useradd -u 1000 -ms /bin/bash -g www www; fi
RUN echo "www:www" | chpasswd

# Чистим кэш
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Меняем пользователя на www
USER www

# В контейнере открываем 9000 порт и запускаем сервер php-fpm
EXPOSE 9000

CMD ["php-fpm"]
