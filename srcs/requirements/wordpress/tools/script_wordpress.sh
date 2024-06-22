#!/bin/bash

if [ ! -f /var/www/wordpress/wp-config.php ]; then
	wp core download --allow-root --locale=es_ES
	while ps aux | grep -q '[w]p core download'; do
		sleep 3
	done
	wp config create	--allow-root		\
				--dbname=$MARIADB_NAME	\
				--dbuser=$MARIADB_USER	\
				--dbpass=$MARIADB_PASS	\
				--dbhost=$DATABASE_HOST	\
				--dbprefix="wp_"	\
				--dbcharset="utf8"          
	while [ ! -f /var/www/wordpress/wp-config.php ]; do
  		sleep 3
	done
	wp core install		--allow-root			\
				--url=$DOMAIN_NAME		\
				--title=$WORDPRESS_TITLE	\
				--admin_user=$WORDPRESS_USER	\
				--admin_password=$WORDPRESS_PASS\
				--admin_email=$WORDPRESS_MAIL	\
                    		--locale=es_ES                  \
				--path=/var/www/wordpress

	wp user create 	$WORDPRESS_AUTHOR $WORDPRESS_MAIL_AUTHOR --user_pass=$WORDPRESS_PASS_AUTHOR \
		       	--role=author \
			--allow-root \
			--path=/var/www/wordpress
fi

/usr/sbin/php-fpm7.4 -y /etc/php/7.4/fpm/php-fpm.conf -F
