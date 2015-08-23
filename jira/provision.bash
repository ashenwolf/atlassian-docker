#!/bin/bash
set -e

echo Downloading Jira $JIRA_VERSION
curl -Lks http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-${JIRA_VERSION}.tar.gz -o /root/jira.tar.gz
/usr/sbin/useradd --create-home --home-dir /opt/jira --groups atlassian --shell /bin/bash jira
tar zxf /root/jira.tar.gz --strip=1 -C /opt/jira
rm /root/jira.tar.gz
echo "jira.home = /opt/atlassian-home" > /opt/jira/atlassian-jira/WEB-INF/classes/jira-application.properties

mv /opt/jira/conf/server.xml /opt/jira/conf/server-backup.xml

chown -R jira:atlassian /opt/jira
