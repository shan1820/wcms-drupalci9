FROM drupal:9-apache

RUN apt-get update && apt-get install -y \
  git \
  imagemagick \
  libmagickwand-dev \
  mariadb-client \
  rsync \
  sudo \
  unzip \
  vim \
  python3 \
  wget && \
  docker-php-ext-install bcmath && \
  docker-php-ext-install mysqli && \
  docker-php-ext-install pdo && \
  docker-php-ext-install pdo_mysql

# Remove the memory limit for the CLI only.
RUN echo 'memory_limit = -1' > /usr/local/etc/php/php-cli.ini

# Remove the vanilla Drupal project that comes with this image.
RUN rm -rf ..?* .[!.]* *

# Install composer.
COPY composer-installer.sh /tmp/composer-installer.sh
RUN chmod +x /tmp/composer-installer.sh && \
    /tmp/composer-installer.sh && \
    mv composer.phar /usr/local/bin/composer && \
    composer self-update --2

# Install XDebug.
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug

# Install node.
RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
    apt install -y nodejs xvfb libgtk-3-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2

# Install Chrome browser.
RUN apt-get install --yes gnupg2 apt-transport-https && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
    sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    apt-get update && \
    apt-get install --yes google-chrome-unstable
    
RUN echo "Finished build of image."
