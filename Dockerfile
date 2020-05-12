#Image
FROM debian:buster

LABEL maintainer="aurbuche <aurbuche@student.42.fr>"

#PREREQUISITES
RUN 	apt-get update && \
		apt-get -y upgrade && \
		apt-get -y install wget && \
		apt-get -y install nginx && \
		apt-get -y install git && \
		apt-get -y install mariadb-server && \
		apt-get -y install php php-fpm php-mysql php-gd php-soap php-curl php-gd php-cli php-mbstring php-xml php-xmlrpc php-zip

# INSTALL PHPMYADMIN && WORDPRESS

RUN		wget -P /tmp https://files.phpmyadmin.net/phpMyAdmin/4.9.2/phpMyAdmin-4.9.2-all-languages.tar.xz
RUN		wget -P /tmp https://wordpress.org/latest.tar.gz

# PHPMYADMIN SETUP

RUN		mkdir -p /var/www/localhost/phpmyadmin
RUN		tar -xf /tmp/phpMyAdmin-4.9.2-all-languages.tar.xz -C /var/www/localhost/phpmyadmin
RUN 	rm /tmp/phpMyAdmin-4.9.2-all-languages.tar.xz
RUN		mkdir /var/www/localhost/phpmyadmin/tmp
RUN		chmod 777 /var/www/localhost/phpmyadmin/tmp/

COPY	srcs/config.inc.php var/www/localhost/phpmyadmin

# MARIADB SETUP

COPY	srcs/wordpress.sql /tmp

RUN		service mysql start && \
		# mariadb < /var/www/localhost/phpmyadmin/sql/create_tables.sql && \
		mariadb -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" && \
		mariadb wordpress < /tmp/wordpress.sql && \
		rm /tmp/wordpress.sql && \
		mariadb -e "GRANT ALL ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'pmapass';" && \
		mariadb -e "GRANT ALL ON wordpress.* TO 'wp_user'@'localhost' IDENTIFIED BY 'password';" && \
		mariadb -e "GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '' WITH GRANT OPTION;" && \
		mariadb -u root -e "FLUSH PRIVILEGES;"

# SSL SETUP

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=68720/L=SPECHBACH/O=ft_server/CN=localhost' -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt >/dev/null 2>&1
RUN openssl dhparam -out /etc/nginx/dhparam.pem 1024  >/dev/null 2>&1

# WORDPRESS SETUP

RUN		tar -zxf /tmp/latest.tar.gz -C /var/www/localhost/ && \
		rm /tmp/latest.tar.gz
COPY 	srcs/wp-config.php /var/www/localhost/wordpress/

# NGINX SETUP

COPY	srcs/localhost /etc/nginx/sites-available/
COPY	srcs/self-signed.conf /etc/nginx/snippets/
COPY	srcs/ssl-params.conf /etc/nginx/snippets/
RUN		ln -s /etc/nginx/sites-available/localhost  /etc/nginx/sites-enabled/ && \
		chown -R www-data:www-data var/www/localhost

EXPOSE	80 443
COPY	srcs/start.sh /tmp/
CMD		bash "/tmp/start.sh"
