���澵��
docker save -o /tmp/jason-php-fpm-v1.tar.gz jason/php-fpm:v1

���뾵��
docker load -i /tmp/jason-php-fpm-v1.tar.gz

������
sudo docker run --name="fpm2" -p 9003:9000 -d -v /home/jason/shared/projects/:/home/jason/shared/projects/ jason/php-fpm:v1

