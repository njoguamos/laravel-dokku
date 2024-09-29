web: php -S 0.0.0.0:80 -t public
scheduler: php /var/www/html/artisan schedule:run
release: php artisan optimize:clear && php artisan optimize && php artisan migrate --force
