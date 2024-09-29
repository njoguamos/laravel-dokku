web: php -S 0.0.0.0:80 -t public
scheduler: php /var/www/html/artisan schedule:run
release: release: php /var/www/html/artisan optimize:clear && php /var/www/html/artisan optimize && php /var/www/html/artisan migrate --force
