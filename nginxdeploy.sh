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
   listen 80;
   #listen [::]:80;
   root /var/www/html;
   index index.php index.html index.htm index.nginx-debian.html;
   server_name localhost;
   location / {
       try_files $uri $uri/ /index.php?\$query_string;
   }
location ~ \.php$ {
    #NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
    include fastcgi_params;                
    fastcgi_intercept_errors on;
    fastcgi_pass unix:/run/php/php7.2-fpm.sock;
    fastcgi_param SCRIPT_FILENAME $document_root/\$fastcgi_script_name;
}
   location ~ /\.ht {
       deny all;
   }
}
EOF
sudo mkdir /home/$USER/html/
sudo rm /var/www/html/*
sudo chown -R www-data:www-data /var/www/html
sudo git clone git@ssh.dev.azure.com:v3/chl-vsts/Marketing/LandingPages
sudo nginx -t
sudo systemctl reload nginx
sudo systemctl restart nginx
echo  "${GREEN}NGINX Setup complete${NC}"
