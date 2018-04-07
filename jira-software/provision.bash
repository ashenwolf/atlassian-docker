#!/bin/bash
set -e

echo Downloading unzip
DEBIAN_FRONTEND=noninteractive apt-get install -q -y unzip

echo Downloading Jira $JIRA_VERSION
#curl -Lks https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${JIRA_VERSION}-jira-${JIRA_VERSION}.tar.gz -o /root/jira.tar.gz
curl -Lks https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${JIRA_VERSION}.zip -o /root/jira.zip
/usr/sbin/useradd --create-home --home-dir /opt/jira --groups atlassian --shell /bin/bash jira
#tar zxf /root/jira.tar.gz --strip=1 -C /opt/jira
ln -s /opt/jira /opt/jira/atlassian-jira-software-$JIRA_VERSION-standalone # create a symlink that redirects output
unzip -a /root/jira.zip -d /opt/jira
rm /opt/jira/atlassian-jira-software-$JIRA_VERSION-standalone # remote symlink
rm /root/jira.zip
echo "jira.home = /opt/atlassian-home/jira" > /opt/jira/atlassian-jira/WEB-INF/classes/jira-application.properties

mv /opt/jira/conf/server.xml /opt/jira/conf/server-backup.xml

chown -R jira:atlassian /opt/jira

