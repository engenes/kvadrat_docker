#!/usr/bin/env bash

configs_dir=./x-docker/nginx/conf.d

# Чистим все конфиги
for config in "${configs_dir}/*"
do
    rm $config
done

# Генерируем конфиги на базе всех сайтов
for site in ./sites/*
do
    domain=$(basename "${site}")
    local_domain=$(echo "${domain}" | sed --regexp-extended 's/\.([a-z]+?)$/-local.\1/g')

    echo "server {
    listen 80;
    listen [::]:80;
    server_name ${local_domain} ${domain};
    return 301 https://${local_domain}\$request_uri;
}

server {
    server_name ${local_domain} ${domain};
    root "/var/www/${domain}/public";
    error_log  /var/log/nginx/${local_domain}-error.log error;
    include common.conf;
    include php.conf;
}" > "${configs_dir}/${domain}.conf"

done


