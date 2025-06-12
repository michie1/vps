echo "0 0 1 * * certbot renew --quiet >/dev/null 2>&1 && curl https://hc-ping.com/a93a1039-cb4e-44e6-a086-ec6be3f26187 > /dev/null" | crontab
# maybe add service nginx restart after certbow renew
