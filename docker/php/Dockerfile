FROM php:fpm

# composerセットアップ
## composerのインストールに必要な拡張をインストール
RUN apt-get update \
  && apt-get install -y libzip-dev \
  && apt-get install -y zlib1g-dev \
  && docker-php-ext-install zip

## インストール
### composerが更新されるとHashが変わってしまうので、その場合は以下のページを見て最新のものに置き換える
### https://getcomposer.org/download/
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('sha384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && mv composer.phar /usr/local/bin/composer

## 環境変数設定
### composerコマンドをrootで実行できるようにする設定
ENV COMPOSER_ALLOW_SUPERUSER 1
### composerのグローバルパッケージがインストールされるディレクトリを設定しPATHを通す
ENV COMPOSER_HOME /composer
ENV PATH $PATH:/composer/vendor/bin

# Laravelセットアップ
## Laravelインストーラをインストール
RUN composer global require "laravel/installer"

## PDOを使用するための設定
RUN apt-get update \
  && apt-get install -y libpq-dev \
  && docker-php-ext-install pdo_mysql pdo_pgsql

## redisを使用するための設定
RUN pecl install -o -f redis \
  && rm -rf /tmp/pear \
  && docker-php-ext-enable redis

# Node.jsセットアップ
## Node.jsインストールに必要なパッケージをインストール
RUN apt-get update \
  && apt-get install -my wget gnupg

## Node.jsインストール（インストールバージョンを切り替えたい場合は、以下のページを見て置き換える）
## https://github.com/nodesource/distributions/blob/master/README.md
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - \
  && apt-get update \
  && apt-get install -y nodejs

# exec時のカレントディレクトリを指定
WORKDIR /work

EXPOSE 9000