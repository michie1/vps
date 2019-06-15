FROM nginx
RUN apt-get update && apt-get install certbot -y
RUN apt-get install cron -y
COPY cert/install_cron.sh /install_cron.sh
RUN bash /install_cron.sh
COPY nginx.conf /etc/nginx/conf.d/default.conf
