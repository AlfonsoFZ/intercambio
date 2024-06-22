FROM debian:bullseye
RUN apt-get -y update &&    \
    apt-get upgrade -y &&   \
    apt-get install -y wget \
    curl            \
    php7.4          \
    php-fpm         \
    php-mysql       \
    mariadb-client
RUN mkdir -p /var/www/wordpress && chown -R www-data:www-data /var/www/wordpress/ && chmod -R 755 /var/www/wordpress/
WORKDIR /var/www/wordpress
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
COPY conf/www.conf /etc/php/7.4/fpm/www.conf
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x /usr/local/bin/wp
COPY tools/script_wordpress.sh /
RUN chmod +x /script_wordpress.sh
EXPOSE 9000

CMD  ["/script_wordpress.sh"]
