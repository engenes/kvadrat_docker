FROM php:8.1.0-fpm

# Set working directory
WORKDIR /var/www

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    locales-all \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libzip-dev \
    libonig-dev \
    nano \
    ruby \
    ruby-dev \
    zsh \
    automake \
    mariadb-client \
    software-properties-common \
    gcc \
    g++ \
    make \
    rsync \
    fzf \
    sudo \
    whois \
    ntp

RUN locale-gen ru_RU.utf8 && dpkg-reconfigure locales-all
# Install extensions
RUN docker-php-ext-install pdo_mysql mysqli mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

RUN gem install capistrano -v 3.14.1
RUN gem install capistrano-copy-files
RUN gem install bcrypt bcrypt_pbkdf ed25519 --platform=ruby

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install starship prompt
RUN if [ ! $(cat /etc/sudoers | grep "ALL ALL=(ALL) ALL") ]; then echo "ALL ALL=(ALL) ALL" >> /etc/sudoers; fi
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- --force

# Add user
RUN if [ ! $(getent group www) ]; then groupadd -g 1000 www; fi
RUN if [ ! $(getent passwd www) ]; then useradd -u 1000 -ms /bin/bash -g www www; fi
RUN echo "www:www" | chpasswd

# ZSH
RUN rm -rf /home/www/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/www/zsh-syntax-highlighting

COPY /x-docker/zsh/exa /usr/local/bin/exa
RUN chmod +x /usr/local/bin/exa

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000

CMD ["php-fpm"]
