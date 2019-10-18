FROM ubuntu:16.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y sphinxsearch wget php7.0-cli php7.0-xmlreader php7.0-zip php7.0-curl
RUN apt-get install -y cron && apt-get install -y supervisor

RUN mkdir /var/www
RUN mkdir /var/www/html

COPY cron-foreground /usr/local/bin/cron-foreground
RUN chmod 700 /usr/local/bin/cron-foreground
COPY searchd-foreground /usr/local/bin/searchd-foreground
RUN chmod 755 /usr/local/bin/searchd-foreground
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/var/lib/sphinxsearch/data"]

EXPOSE 9312 9306

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

