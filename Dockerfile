FROM nextcloud:35.0.2-apache

USER root

RUN apt-get update \
    && apt-get install -y procps smbclient \
    && rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.source="https://github.com/simon-sebold/nextcloud-customized"
