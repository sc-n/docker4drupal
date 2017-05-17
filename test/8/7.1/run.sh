#!/usr/bin/env bash

set -e

if [[ ! -z "${DEBUG}" ]]; then
  set -x
fi

. ../../images.env

docker-compose up -d
docker-compose exec mariadb make check-ready wait_seconds=5 max_try=12 -f /usr/local/bin/actions.mk
docker-compose exec solr make check-ready wait_seconds=3 max_try=12 -f /usr/local/bin/actions.mk
docker-compose exec solr make core=core1 -f /usr/local/bin/actions.mk
docker-compose exec php chown -R www-data:www-data .
docker-compose exec --user=82 php ./test.sh
docker-compose down
