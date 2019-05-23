echo "${CYAN}Step:2 [Install NGINX]${NC}"
sudo apt-get install -y nginx
echo  "${GREEN}NGINX Installation Completed Successfully\n${NC}"

echo "${CYAN}Step:4 [Install PHP7.2]${NC}"
#sudo apt-get install -y software-properties-common
#sudo add-apt-repository ppa:ondrej/php -y 
sudo apt-get -y update
sudo apt-get install -y php7.2
#sudo apt-cache search php7.2
sudo apt-get install -y  php7.2-cli php7.2-fpm php7.2-mysql php7.2-curl php7.2-json php7.2-cgi libphp7.2-embed libapache2-mod-php7.2 php7.2-zip php7.2-mbstring php7.2-xml php7.2-intl

echo  "${GREEN}PHP 7.2 Installation Completed Successfully\n${NC}"

sudo systemctl start php7.2-fpm
sudo systemctl enable php7.2-fpm

sudo systemctl restart nginx

echo "${CYAN}Remove the default symlink in sites-enabled directory${NC}"
sudo rm /etc/nginx/sites-enabled/default
sudo cat > /etc/nginx/sites-enabled/default.conf <<EOF
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # listen 443 ssl default_server;
        # listen [::]:443 ssl default_server;

        root /var/www/html/LandingPages;

        index index.php index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                try_files \$uri \$uri/ /index.php\$is_args\$args;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;

                fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        }

}
EOF
#sudo mkdir /home/$USER/html/
rm /var/www/html/*
chown -R www-data:www-data /var/www/html
mkdir /root/.ssh && chmod 0700 /root/.ssh 
ssh-keyscan ssh.dev.azure.com >> /root/.ssh/known_hosts
cd /var/www/html && git clone git@ssh.dev.azure.com:v3/chl-vsts/Marketing/LandingPages
chown  www-data:www-data /var/www/html -R
sudo nginx -t
sudo systemctl reload nginx
sudo systemctl restart nginx
sudo systemctl start php7.2-fpm
sudo systemctl enable php7.2-fpm
sudo systemctl enable nginx
sudo systemctl disable apache2
rm /var/www/html/*id_rsa
rm /var/www/html/*.sh
rm /var/www/html/*.json
echo  "${GREEN}NGINX Setup complete${NC}"
