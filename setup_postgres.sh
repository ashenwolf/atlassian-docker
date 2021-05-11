#!/bin/bash

. settings/settings.sh

cd "$(dirname $0)"

# Postgres

$SUDO docker pull postgres:12.2
$SUDO docker run -d --name postgres12 -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD postgres:12.2
cat pg/init_db.sh | $SUDO docker run --rm -i --link postgres12:db -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD postgres bash -

