#!/bin/bash

PSQL_IP=$DB_PORT_5432_TCP_ADDR
PSQL_PORT=$DB_PORT_5432_TCP_PORT

# Saves password
echo "$PSQL_IP:*:*:postgres:$POSTGRES_PASSWORD" > $HOME/.pgpass
chmod 0600 $HOME/.pgpass

