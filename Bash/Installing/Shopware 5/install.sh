#!/usr/bin/env bash

# Installation parameters

repo_tag='v5.6.7'
db_user='root'
db_password='vagrant'
db_host='localhost'
sw_host_port='9001'


# Installing needed packages

sudo aptitude install -y php-intl php-curl php-gd php-mbstring php-xml php-zip
sudo aptitude install -y unzip

# Installing

cd /srv/web/

git clone -b $repo_tag https://github.com/shopware/shopware.git

cd /srv/web/shopware

mv .psh.yaml.dist .psh.yaml

sed -i "/^[^#]*DB_USER:/c\  DB_USER: \"$db_user\"" .psh.yaml
sed -i "/^[^#]*DB_PASSWORD:/c\  DB_PASSWORD: \"$db_password\"" .psh.yaml
sed -i "/^[^#]*DB_HOST:/c\  DB_HOST: \"$db_host\"" .psh.yaml
sed -i "/^[^#]*SW_HOST: \"localhost:8088\"/c\  SW_HOST: \"localhost:$sw_host_port\"" .psh.yaml

./psh.phar init

wget -O test_images.zip http://releases.s3.shopware.com/test_images_since_5.1.zip
unzip -o test_images.zip

sudo chown www-data:www-data -R .
sudo chmod a+rwx -R .

sudo grep -qxF "Listen $sw_host_port" /etc/apache2/ports.conf || sudo sed -i "\$iListen $sw_host_port" /etc/apache2/ports.conf

sudo tee <<EOF /etc/apache2/sites-available/shopware.conf > /dev/null
<VirtualHost *:$sw_host_port>
     ServerAdmin admin@localhost
     DocumentRoot /srv/web/shopware
     ServerName localhost

     <Directory /srv/web/shopware/>
          Options FollowSymlinks
          AllowOverride All
          Require all granted
     </Directory>

     ErrorLog \${APACHE_LOG_DIR}/error.log
     CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo a2enmod rewrite    # To ensure that it is enabled
sudo a2ensite shopware
sudo systemctl restart apache2

