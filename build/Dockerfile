FROM debian:bullseye-slim
ARG TARGETARCH
ARG PHP_VERSION

# pre-build
COPY config/keyboard /etc/default/keyboard

# build
COPY build.sh /build.sh
RUN bash /build.sh && rm /build.sh

# sourceguardian
COPY extension/loaders.linux-*.tar.bz2 /tmp/

COPY add-sourceguardian.sh /add-sourceguardian.sh
RUN bash /add-sourceguardian.sh && rm /add-sourceguardian.sh

RUN rm /tmp/loaders.linux-*.tar.bz2

# post-build
COPY scripts/cron-foreground /usr/local/bin/cron-foreground
RUN chmod 700 /usr/local/bin/cron-foreground
COPY scripts/searchd-foreground /usr/local/bin/searchd-foreground
RUN chmod 755 /usr/local/bin/searchd-foreground
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 9312 9306

WORKDIR /var/www/html
VOLUME ["/var/lib/sphinxsearch/data"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
