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

xmlstarlet ed -u '//Context/@path' -v "$CONTEXT_PATH" conf/server-backup.xml > conf/server.xml

/opt/confluence/bin/start-confluence.sh -fg
