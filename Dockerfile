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
			apt-get -y install default-mysql-server && \
			apt-get -y install default-mysql-client && \
			apt-get -y install php php-fpm php-mysql php-gd php-soap php-curl php-gd php-cli php-mbstring php-xml php-xmlrpc php-zip && \
			apt-get -y install libnss3-tools


EXPOSE		80 443

COPY		srcs/localhost.conf /etc/nginx/sites-available/default

WORKDIR		/var/www/html

# Home page setup

COPY		srcs/index.html ./
COPY		srcs/index.css ./
COPY 		srcs/logo_wordpress.jpg ./
COPY 		srcs/logo_phpmyadmin.jpg ./
COPY		srcs/subject.jpg ./
COPY		srcs/en.subject.pdf	./

RUN			echo "\033[38;2;0;128;0mThe home page is ready!\033[0m"

# Wordpress setup

RUN			wget -q https://fr.wordpress.org/latest-fr_FR.tar.gz

RUN 		tar xf latest-fr_FR.tar.gz && \
			rm -f latest-fr_FR.tar.gz

COPY		srcs/wp-config.php wordpress/

RUN			echo "\033[38;2;0;128;0mWordpress is install\033[0m"

# PHPMyAdmin setup
RUN			wget -q https://files.phpmyadmin.net/phpMyAdmin/4.9.2/phpMyAdmin-4.9.2-all-languages.tar.xz

RUN			tar -xf phpMyAdmin-4.9.2-all-languages.tar.xz && \
	 		rm phpMyAdmin-4.9.2-all-languages.tar.xz && \
			mv phpMyAdmin-4.9.2-all-languages ./phpmyadmin

RUN			echo "\033[38;2;0;128;0mPHPMyAdmin is install\033[0m"

# Mariadb setup

RUN 		service mysql start && \
			echo "CREATE DATABASE wordpress;" | mysql -u root && \
			echo "ALTER USER root@localhost IDENTIFIED VIA mysql_native_password;"  | mysql -u root && \
			echo "CREATE user user@localhost identified by 'password';" | mysql -u root && \
			echo "SET PASSWORD = PASSWORD('password');" | mysql -u root && \
			echo "grant all privileges on wordpress.* to user@localhost;" | mysql -u root && \
			echo "flush privileges;" | mysql -u root

RUN			echo "\033[38;2;0;128;0mThe database is up!\033[0m"

# OpenSSL setup

RUN 		mkdir ~/mkcert && \
			cd ~/mkcert && \
			wget -q https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64 && \
			mv mkcert-v1.1.2-linux-amd64 mkcert && \
			chmod +x mkcert && \
			./mkcert -install && \
			./mkcert localhost && \
			cp /root/mkcert/* /etc/nginx/

RUN			echo "\033[38;2;0;128;0mYou have the certification my boy!\033[0m"

# Final setup

COPY		srcs/config.inc.php ./phpmyadmin/

RUN 		chmod 660 /var/www/html/phpmyadmin/config.inc.php && chown -R www-data:www-data /var/www/html/phpmyadmin && \
			chown www-data:www-data * -R && usermod -a -G www-data www-data

COPY		srcs/start.sh /tmp/
CMD			bash "/tmp/start.sh"

RUN			echo "\033[38;2;0;128;0mEverything is up!\033[0m" && \
			echo "\033[38;2;0;128;0mNow type this command: docker run -d -p 80:80 -p 443:443 ft_server\033[0m" && \
			echo "\033[38;2;0;128;0mAfter that everything will be OK, you can go to https://localhost and see your container ✅\033[0m"