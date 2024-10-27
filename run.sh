if [[ $1 == "client" ]]; then
    echo 'nameserver 192.168.122.1' > /etc/resolv.conf
   
    apt-get update

    apt-get install lynx -y
    apt-get install apache2-utils -y

elif [[ $1 == "dhcp-relay" ]]; then
    echo 'nameserver 192.168.122.1' > /etc/resolv.conf

    apt-get update
    apt-get install isc-dhcp-relay -y
    service isc-dhcp-relay start

    echo 'SERVERS="192.242.4.3"' > /etc/default/isc-dhcp-relay
    echo 'INTERFACES="eth1 eth2 eth3 eth4"' >> /etc/default/isc-dhcp-relay
    echo 'OPTIONS=""' >> /etc/default/isc-dhcp-relay

    echo 'net.ipv4.ip_forward=1' > /etc/sysctl.conf

    service isc-dhcp-relay restart 

elif [[ $1 == "dns-server" ]]; then
    echo 'nameserver 192.168.122.1' > /etc/resolv.conf

    apt-get update
    apt-get install bind9 -y

    echo 'zone "marley.it18.com" {' > /etc/bind/named.conf.local
    echo '    type master;' >> /etc/bind/named.conf.local
    echo '    file "/etc/bind/jarkom/marley.it18.com";' >> /etc/bind/named.conf.local
    echo '};' >> /etc/bind/named.conf.local

    echo 'zone "eldia.it18.com" {' >> /etc/bind/named.conf.local
    echo '    type master;' >> /etc/bind/named.conf.local
    echo '    file "/etc/bind/jarkom/eldia.it18.com";' >> /etc/bind/named.conf.local
    echo '};' >> /etc/bind/named.conf.local

    echo 'options {' > /etc/bind/named.conf.options
    echo '    directory "/var/cache/bind";' >> /etc/bind/named.conf.options
    echo '' >> /etc/bind/named.conf.options
    echo '    forwarders {' >> /etc/bind/named.conf.options
    echo '        192.168.122.1;' >> /etc/bind/named.conf.options
    echo '        8.8.8.8;' >> /etc/bind/named.conf.options
    echo '    };' >> /etc/bind/named.conf.options
    echo '    allow-query { any; };' >> /etc/bind/named.conf.options
    echo '    listen-on-v6 { any; };' >> /etc/bind/named.conf.options
    echo '};' >> /etc/bind/named.conf.options

    mkdir /etc/bind/jarkom

    echo ";" > /etc/bind/jarkom/marley.it18.com
    echo "; BIND data file for local loopback interface" >> /etc/bind/jarkom/marley.it18.com
    echo ";" >> /etc/bind/jarkom/marley.it18.com
    echo "\$TTL    604800" >> /etc/bind/jarkom/marley.it18.com
    echo "@       IN      SOA     marley.it18.com. root.marley.it18.com. (" >> /etc/bind/jarkom/marley.it18.com
    echo "                              2         ; Serial" >> /etc/bind/jarkom/marley.it18.com
    echo "                         604800         ; Refresh" >> /etc/bind/jarkom/marley.it18.com
    echo "                          86400         ; Retry" >> /etc/bind/jarkom/marley.it18.com
    echo "                        2419200         ; Expire" >> /etc/bind/jarkom/marley.it18.com
    echo "                         604800 )       ; Negative Cache TTL" >> /etc/bind/jarkom/marley.it18.com
    echo ";" >> /etc/bind/jarkom/marley.it18.com
    echo "@       IN      NS      marley.it18.com." >> /etc/bind/jarkom/marley.it18.com
    echo "@       IN      A       192.242.1.2 ; IP Annie" >> /etc/bind/jarkom/marley.it18.com

    echo ";" > /etc/bind/jarkom/eldia.it18.com
    echo "; BIND data file for local loopback interface" >> /etc/bind/jarkom/eldia.it18.com
    echo ";" >> /etc/bind/jarkom/eldia.it18.com
    echo "\$TTL    604800" >> /etc/bind/jarkom/eldia.it18.com
    echo "@       IN      SOA     eldia.it18.com. root.eldia.it18.com. (" >> /etc/bind/jarkom/eldia.it18.com
    echo "                              2         ; Serial" >> /etc/bind/jarkom/eldia.it18.com
    echo "                         604800         ; Refresh" >> /etc/bind/jarkom/eldia.it18.com
    echo "                          86400         ; Retry" >> /etc/bind/jarkom/eldia.it18.com
    echo "                        2419200         ; Expire" >> /etc/bind/jarkom/eldia.it18.com
    echo "                         604800 )       ; Negative Cache TTL" >> /etc/bind/jarkom/eldia.it18.com
    echo ";" >> /etc/bind/jarkom/eldia.it18.com
    echo "@       IN      NS      eldia.it18.com." >> /etc/bind/jarkom/eldia.it18.com
    echo "@       IN      A       192.242.2.2 ; IP Armin" >> /etc/bind/jarkom/eldia.it18.com

    service bind9 restart

elif [[ $1 == "dhcp-server" ]]; then
    echo 'nameserver 192.168.122.1' > /etc/resolv.conf

    apt-get update
    apt-get install isc-dhcp-server -y

    echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server
    echo 'INTERFACESv6=""' >> /etc/default/isc-dhcp-server

    echo 'option domain-name "example.org";' > /etc/dhcp/dhcpd.conf
    echo 'option domain-name-servers ns1.example.org, ns2.example.org;' >> /etc/dhcp/dhcpd.conf
    echo '' >> /etc/dhcp/dhcpd.conf
    echo 'default-lease-time 600;' >> /etc/dhcp/dhcpd.conf
    echo 'max-lease-time 7200;' >> /etc/dhcp/dhcpd.conf
    echo '' >> /etc/dhcp/dhcpd.conf
    echo 'ddns-update-style none;' >> /etc/dhcp/dhcpd.conf
    echo '' >> /etc/dhcp/dhcpd.conf

    echo 'subnet 192.242.1.0 netmask 255.255.255.0 {' >> /etc/dhcp/dhcpd.conf
    echo '    range 192.242.1.5 192.242.1.25;' >> /etc/dhcp/dhcpd.conf
    echo '    range 192.242.1.50 192.242.1.100;' >> /etc/dhcp/dhcpd.conf
    echo '    option routers 192.242.1.1;' >> /etc/dhcp/dhcpd.conf
    echo '    option broadcast-address 192.242.1.255;' >> /etc/dhcp/dhcpd.conf
    echo '    option domain-name-servers 192.242.4.2;' >> /etc/dhcp/dhcpd.conf
    echo '    default-lease-time 1800;' >> /etc/dhcp/dhcpd.conf
    echo '    max-lease-time 5220;' >> /etc/dhcp/dhcpd.conf
    echo '}' >> /etc/dhcp/dhcpd.conf
    echo '' >> /etc/dhcp/dhcpd.conf

    echo 'subnet 192.242.2.0 netmask 255.255.255.0 {' >> /etc/dhcp/dhcpd.conf
    echo '    range 192.242.2.9 192.242.2.27;' >> /etc/dhcp/dhcpd.conf
    echo '    range 192.242.2.81 192.242.2.243;' >> /etc/dhcp/dhcpd.conf
    echo '    option routers 192.242.2.1;' >> /etc/dhcp/dhcpd.conf
    echo '    option broadcast-address 192.242.2.255;' >> /etc/dhcp/dhcpd.conf
    echo '    option domain-name-servers 192.242.4.2;' >> /etc/dhcp/dhcpd.conf
    echo '    default-lease-time 360;' >> /etc/dhcp/dhcpd.conf
    echo '    max-lease-time 5220;' >> /etc/dhcp/dhcpd.conf
    echo '}' >> /etc/dhcp/dhcpd.conf
    echo '' >> /etc/dhcp/dhcpd.conf

    echo 'subnet 192.242.3.0 netmask 255.255.255.0 {' >> /etc/dhcp/dhcpd.conf
    echo '}' >> /etc/dhcp/dhcpd.conf
    echo '' >> /etc/dhcp/dhcpd.conf

    echo 'subnet 192.242.4.0 netmask 255.255.255.0 {' >> /etc/dhcp/dhcpd.conf
    echo '}' >> /etc/dhcp/dhcpd.conf
    
    service isc-dhcp-server restart

elif [[ $1 == "worker-php" ]]; then
    echo 'nameserver 192.242.4.2' > /etc/resolv.conf # IP DNS-SERVER

    apt-get update

    apt-get install nginx -y
    apt-get install lynx -y
    apt-get install php7.3 php7.3-fpm php7.3-mysql -y   # Install PHP 7.3 dan modul yang diperlukan
    apt-get install wget -y
    apt-get install unzip -y
    apt-get install rsync -y    # Install rsync untuk transfer file
    service nginx start
    service php7.3-fpm start    # Jalankan PHP-FPM versi 7.3

    wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1ufulgiWyTbOXQcow11JkXG7safgLq1y-' -O '/var/www/modul-3.zip'

    unzip -o /var/www/modul-3.zip -d /var/www/
    rm /var/www/modul-3.zip

    rsync -av /var/www/modul-3/ /var/www/eldia.it18.com/

    rm -r /var/www/modul-3

    cp /etc/nginx/sites-available/default /etc/nginx/sites-available/eldia.it18.com

    ln -s /etc/nginx/sites-available/eldia.it18.com /etc/nginx/sites-enabled/

    rm /etc/nginx/sites-enabled/default

    echo 'server {
        listen 80;
        server_name _;

        root /var/www/eldia.it18.com;
        index index.php index.html index.htm;

        location / {
            try_files $uri $uri/ /index.php?$query_string;
        }

        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/run/php/php7.3-fpm.sock;  # Sesuaikan versi PHP dan socket
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }
    }' > /etc/nginx/sites-available/eldia.it18.com

    service nginx restart
    service php7.3-fpm restart

    elif [[ $1 == "lb-php" ]]; then
    echo 'nameserver 192.242.4.2' > /etc/resolv.conf

    apt-get update

    apt-get install apache2-utils -y   # Untuk testing menggunakan ApacheBench (ab)
    apt-get install nginx -y           # Install Nginx sebagai load balancer
    apt-get install lynx -y            # Install lynx untuk akses web via command line

    cp /etc/nginx/sites-available/default /etc/nginx/sites-available/colossal_lb

    echo "upstream php_backend {
        server 192.242.2.2;  # Armin
        server 192.242.2.3;  # Eren
        server 192.242.2.4;  # Mikasa
    }

    server {
        listen 80;
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name eldia.it18.com;

        location / {
            proxy_pass http://php_backend;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }" > /etc/nginx/sites-enabled/colossal_lb

    ln -sf /etc/nginx/sites-available/colossal_lb /etc/nginx/sites-enabled/

    rm -r /etc/nginx/sites-enabled/default

    service nginx restart

else
    echo "Usage: $0 [dhcp-relay|dns-server|dhcp-server|client|worker-php|lb-php]"
    exit 1
fi
