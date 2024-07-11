FROM docker.io/dunglas/frankenphp:1-php8.2
ENV CADDY_GLOBAL_OPTIONS="admin off"

HEALTHCHECK --start-period=15s --retries=2 --interval=60s CMD curl --fail $SERVER_NAME || exit 1

RUN install-php-extensions \
        intl \
        gd \
        mysqli \
        pdo_mysql \
        soap \
        zip \
        imap \
        ldap

COPY init_suitecrm.sh /usr/local/bin/init_suitecrm.sh

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    chmod +x /usr/local/bin/init_suitecrm.sh && \
	sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/' $PHP_INI_DIR/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 20M/' $PHP_INI_DIR/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = 256M/' $PHP_INI_DIR/php.ini

COPY ./suitecrm /app
ENV FRANKENPHP_DOCUMENT_ROOT=/app/public

CMD ["/usr/local/bin/init_suitecrm.sh"]
