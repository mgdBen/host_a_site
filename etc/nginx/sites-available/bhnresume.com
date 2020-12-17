server {

        root /opt/www/bhnresume/html;
        index index.html index.htm index.nginx-debian.html;

        server_name bhnresume.com www.bhnresume.com;

        location / {
                try_files $uri $uri/ =404;
        }

    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/bhnresume.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/bhnresume.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}
server {
    if ($host = www.bhnresume.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = bhnresume.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


        listen 80;
        listen [::]:80;

        server_name bhnresume.com www.bhnresume.com;
    return 404; # managed by Certbot




}
