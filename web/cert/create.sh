#certbot certonly --manual --preferred-challenges=dns --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d *.msvos.nl -d msvos.nl
certbot certonly --webroot -w /usr/share/nginx/html -d msvos.nl -d sp.msvos.nl -d tt.msvos.nl -d wt.msvos.nl -d nb.msvos.nl -d gt.msvos.nl
