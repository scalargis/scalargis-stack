#!/bin/sh
set -e
cd "$(dirname "$0")"

git submodule update --init

if [ -f .env ]; then
  echo ".env exists, no change."
  exit 0
fi

secret() {
  LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c "$1"
}

db_pass=$(secret 24)
sed -e "s/^DB_PASS=.*/DB_PASS=$db_pass/" \
    -e "s/^POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$db_pass/" \
    -e "s/^SECRET_KEY=.*/SECRET_KEY=$(secret 48)/" \
    -e "s/^SECURITY_PASSWORD_SALT=.*/SECURITY_PASSWORD_SALT=$(secret 32)/" \
    -e "s/^GEOSERVER_ADMIN_PASSWORD=.*/GEOSERVER_ADMIN_PASSWORD=$(secret 20)/" \
    .env.example > .env

echo ".env written. Next: docker compose up -d --build"
