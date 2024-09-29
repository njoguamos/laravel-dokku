# https://serversideup.net/open-source/docker-php/
FROM serversideup/php:8.3-unit

# Build argument -> remove this if you do not need NodeJS
ARG NODE_VERSION=20

# Do not run the automatic laravel commands
# that comes with the base image
ENV AUTORUN_ENABLED=false

# Switch to root so we can do root things
USER root

# Install the intl extension for translations
RUN install-php-extensions exif

# Install NodeJS -> remove this if you do not need NodeJS
RUN apt-get update \
    && apt-get install -y bash \
    && curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x -o nodesource_setup.sh \
    && bash nodesource_setup.sh \
    && apt-get install -y nodejs \
    && apt-get install -y jpegoptim optipng pngquant gifsicle libavif-bin \
    && npm install -g svgo \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Switch to www-data user
USER www-data

# Install composer dependencies
COPY --chown=www-data:www-data composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-scripts --no-autoloader --no-progress --ignore-platform-reqs

# Install node dependencies -> remove this if you do not need NodeJS
COPY --chown=www-data:www-data package.json ./
RUN npm install --frozen-lockfile

# Copy the app files to the container
COPY --chown=www-data:www-data . .

# Build node dependencies -> remove this if you do not need NodeJS
RUN npm run build

# Autoload files
RUN composer dump-autoload --optimize

# Prepare the laravel app
RUN php /var/www/html/artisan optimize:clear \
RUN php /var/www/html/artisan optimize \
    && php /var/www/html/artisan storage:link
