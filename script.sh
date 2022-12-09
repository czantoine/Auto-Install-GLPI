# GLPI VERSION
export VER="10.0.5"

sudo apt-get -y update
# sudo apt-get -y upgrade

sudo apt-get -y install apache2 mariadb-server wget libapache2-mod-perl2 libapache-dbi-perl libapache-db-perl php7.4 libapache2-mod-php7.4 php7.4-common php7.4-sqlite3 php7.4-mysql php7.4-gmp php-cas php-pear php7.4-curl php7.4-mbstring php7.4-gd php7.4-cli php7.4-xml php7.4-zip php7.4-soap php7.4-json php-pclzip composer php7.4-intl php7.4-apcu php7.4-memcache php7.4-ldap php7.4-tidy php7.4-xmlrpc php7.4-pspell php7.4-json php7.4-xml php7.4-gd php7.4-bz2
sudo systemctl enable apache2

sudo mysql -u root -e "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE User = 'root';"
sudo mysql -u root -e "flush privileges;"
sudo mysql -u root -e "quit"

sudo mysql -u root -e "CREATE DATABASE glpi;"
sudo mysql -u root -e "CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';"
sudo mysql -u root -e "flush privileges;"
sudo mysql -u root -e "exit"

sudo systemctl restart mariadb

sudo bash -c 'cat >> /etc/php/7.4/apache2/php.ini' << EOF
memory_limit = 512M
post_max_size = 100M
upload_max_filesize = 100M
max_execution_time = 360
date.timezone = Europe/Paris
EOF

wget https://github.com/glpi-project/glpi/releases/download/$VER/glpi-$VER.tgz
tar xvf glpi-$VER.tgz
sudo mv glpi /var/www/html/
sudo chown -R www-data:www-data /var/www/html/glpi

sudo bash -c 'cat >> /etc/apache2/apache2.conf' << EOF
<Directory /var/www/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>
EOF

sudo systemctl restart apache2