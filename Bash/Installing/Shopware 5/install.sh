cd shopware

./psh.phar init

wget -O test_images.zip http://releases.s3.shopware.com/test_images_since_5.1.zip
unzip -o test_images.zip

sudo chown www-data:www-data -R .
sudo chmod a+rwx -R .
