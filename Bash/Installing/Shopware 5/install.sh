#!/usr/bin/env bash

#################
# 
# This installation script was tested for v5.5.10 and v5.6.7
# 
#################

# Installation parameters

install_base_path='/srv/web'    # Don't Include trailing slash
install_dir='shopware-5.6'      # Don't Include trailing slash
repo_tag='v5.6.7'
db_host='localhost'
db_user='root'
db_password='vagrant'
sw_host_port='9001'


# Installing needed packages

echo '###################### Installing needed packages ######################'
sudo aptitude install -y php-intl php-curl php-gd php-mbstring php-xml php-zip
sudo aptitude install -y ant        # Not needed for shopware v5.6.7
sudo aptitude install -y unzip      # Not really needed. If not installed php will be used for unzipping,
                                    # but that is apparantly not recommended or atleast not as efficient

# Installing

cd $install_base_path

echo '###################### Cloning git repository ######################'
git clone -b $repo_tag https://github.com/shopware/shopware.git $install_dir

cd "$install_base_path/$install_dir"

echo '###################### Preparing ".psh.yaml" ######################'
mv .psh.yaml.dist .psh.yaml

sed -i "/^[^#]*DB_USER:/c\  DB_USER: \"$db_user\"" .psh.yaml
sed -i "/^[^#]*DB_PASSWORD:/c\  DB_PASSWORD: \"$db_password\"" .psh.yaml
sed -i "/^[^#]*DB_HOST:/c\  DB_HOST: \"$db_host\"" .psh.yaml
sed -i "/^[^#]*SW_HOST: \"localhost:8088\"/c\  SW_HOST: \"localhost:$sw_host_port\"" .psh.yaml

echo '###################### Executing ".psh.yaml" ######################'
./psh.phar init

echo '###################### Downloading and unzipping "test_images_since_5.1.zip" ######################'
wget -O test_images.zip http://releases.s3.shopware.com/test_images_since_5.1.zip
unzip -o test_images.zip

echo '###################### Changing ownership and permission ######################'
sudo chown www-data:www-data -R .
sudo chmod a+rwx -R .

echo '###################### Ensuring Apache to appropriate port ######################'
sudo grep -qxF "Listen $sw_host_port" /etc/apache2/ports.conf || sudo sed -i "\$iListen $sw_host_port" /etc/apache2/ports.conf

echo '###################### Creating config file ######################'
sudo tee <<EOF /etc/apache2/sites-available/$install_dir.conf > /dev/null
<VirtualHost *:$sw_host_port>
     ServerAdmin admin@localhost
     DocumentRoot $install_base_path/$install_dir
     ServerName localhost

     <Directory $install_base_path/$install_dir>
          Options FollowSymlinks
          AllowOverride All
          Require all granted
     </Directory>

     ErrorLog \${APACHE_LOG_DIR}/error-$install_dir.log
     CustomLog \${APACHE_LOG_DIR}/access-$install_dir.log combined
</VirtualHost>
EOF

echo '###################### Activating needed apache objects and restarting ######################'
sudo a2enmod rewrite    # To ensure that it is enabled
sudo a2ensite $install_dir
sudo systemctl restart apache2

