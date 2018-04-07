#!/bin/bash
set -o errexit

. /usr/local/share/atlassian/common.bash

sudo own-volume
rm -f /opt/atlassian-home/.confluence-home.lock

if [ "$CONTEXT_PATH" == "ROOT" -o -z "$CONTEXT_PATH" ]; then
  CONTEXT_PATH=
else
  CONTEXT_PATH="/$CONTEXT_PATH"
fi

#xmlstarlet ed -u '//Context/@path' -v "$CONTEXT_PATH" conf/server-backup.xml > conf/server.xml

if [ -n "$DATABASE_URL" ]; then
  extract_database_url "$DATABASE_URL" DB /opt/jira/lib
  DB_JDBC_URL="$(xmlstarlet esc "$DB_JDBC_URL")"
  SCHEMA=''
  if [ "$DB_TYPE" != "mysql" ]; then
    SCHEMA='<schema-name>public</schema-name>'
  fi

xmlstarlet ed -P -S -s "//Context/@path=''" -t elem -n ResourceTMP -v "" \
    -i //ResourceTMP -t attr -n "name" -v "jdbc/confluence" \
    -i //ResourceTMP -t attr -n "auth" -v "Container" \
    -i //ResourceTMP -t attr -n "type" -v "javax.sql.DataSource" \
    -i //ResourceTMP -t attr -n "driverClassName" -v "$DB_JDBC_DRIVER" \
    -i //ResourceTMP -t attr -n "url" -v "$DB_JDBC_URL" \
    -i //ResourceTMP -t attr -n "username" -v "$DB_USER" \
    -i //ResourceTMP -t attr -n "password" -v "$DB_PASSWORD" \
    -i //ResourceTMP -t attr -n "maxTotal" -v "60" \
    -i //ResourceTMP -t attr -n "maxIdle" -v "10" \
    -i //ResourceTMP -t attr -n "validationQuery" -v "SELECT 1" \
    -r //ResourceTMP -v Resource \
    conf/server-backup.xml > conf/server.xml
fi
/opt/confluence/bin/start-confluence.sh -fg
