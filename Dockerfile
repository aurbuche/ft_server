# Image
FROM debian:buster

LABEL maintainer="aurbuche <aurbuche@student.42.fr>"

# Install packages
RUN 		apt-get update && \
			apt-get -y upgrade && \
			apt-get -y install wget && \
			apt-get -y install nginx && \
			apt-get -y install git && \
			apt-get -y install mariadb-server && \
			apt-get -y install default-mysql-client && \
			apt-get -y install php php-fpm php-mysql php-gd php-soap php-curl php-gd php-cli php-mbstring php-xml php-xmlrpc php-zip

# Create the directories

RUN			mkdir /var/www/localhost
RUN			mkdir /var/www/localhost/wordpress

# Get PHPMyAdmin & Wordpress

RUN			wget -qP /tmp https://files.phpmyadmin.net/phpMyAdmin/4.9.2/phpMyAdmin-4.9.2-all-languages.tar.xz
# RUN			wget -qP /tmp https://wordpress.org/latest.tar.gz

# Home page setup

COPY		srcs/index.html /var/www/localhost
COPY		srcs/index.css /var/www/localhost
COPY 		srcs/logo_wordpress.jpg /var/www/localhost
COPY 		srcs/logo_phpmyadmin.jpg /var/www/localhost
COPY		srcs/subject.jpg /var/www/localhost
COPY		srcs/fr.subject.pdf	/var/www/localhost

# Wordpress setup

RUN 		tar -zxf /tmp/latest.tar.gz -C /var/www/localhost/wordpress && \
			rm /tmp/latest.tar.gz 

RUN			echo "\033[38;2;0;128;0mWordpress is install\033[0m"

# PHPMyAdmin setup

RUN			tar -xf /tmp/phpMyAdmin-4.9.2-all-languages.tar.xz && \
	 		rm /tmp/phpMyAdmin-4.9.2-all-languages.tar.xz && \
			mv phpMyAdmin-4.9.2-all-languages /var/www/localhost/phpmyadmin
RUN			echo "\033[38;2;0;128;0mPHPMyAdmin is install\033[0m"

COPY		srcs/config.inc.php /var/www/localhost/phpmyadmin/

# Mariadb setup

RUN			service mysql start && \
			mariadb -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" && \
			mariadb -e "GRANT ALL ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'pmapass';" && \
			mariadb -e "GRANT ALL ON wordpress.* TO 'wp_user'@'localhost' IDENTIFIED BY 'password';" && \
			mariadb -e "GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '' WITH GRANT OPTION;" && \
			mariadb -u root -e "FLUSH PRIVILEGES;"

RUN			echo "\033[38;2;0;128;0mThe database is up!\033[0m"

# OpenSSL setup

RUN 		openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=69008/L=LYON/O=42/CN=localhost' -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt >/dev/null 2>&1
RUN 		openssl dhparam -out /etc/nginx/dhparam.pem 1024  >/dev/null 2>&1

RUN			echo "\033[38;2;0;128;0mYou have the certification my boy!\033[0m"

# Nginx setup

COPY		srcs/localhost /etc/nginx/sites-available/
COPY		srcs/self-signed.conf /etc/nginx/snippets/
COPY		srcs/ssl-params.conf /etc/nginx/snippets/
RUN			ln -s /etc/nginx/sites-available/localhost  /etc/nginx/sites-enabled/ && \
			chown -R www-data:www-data /var/www/localhost

# Final setup
EXPOSE		80 443
COPY		srcs/start.sh /tmp/
CMD			bash "/tmp/start.sh"

RUN			echo "\033[38;2;0;128;0mEverything is OK, you can go to https://localhost to see your container ✅\033[0m"
