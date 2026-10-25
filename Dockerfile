FROM nextcloud:35.0.2-apache

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        procps \
        smbclient \
        libsmbclient-dev \
    && pecl install smbclient \
    && docker-php-ext-enable smbclient \
    && apt-get purge -y --auto-remove libsmbclient-dev \
    && rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.source="https://github.com/simon-sebold/nextcloud-customized"
