#!/bin/bash
set -e

echo Downloading Crowd ${CROWD_VERSION}
curl -Lks http://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-${CROWD_VERSION}.tar.gz -o /root/crowd.tar.gz
/usr/sbin/useradd --create-home --home-dir /opt/crowd --groups atlassian --shell /bin/bash crowd
tar zxf /root/crowd.tar.gz --strip=1 -C /opt/crowd
rm /root/crowd.tar.gz
echo "crowd.home = /opt/atlassian-home" > /opt/crowd/crowd-webapp/WEB-INF/classes/crowd-init.properties

mv /opt/crowd/apache-tomcat/webapps/ROOT /opt/crowd/splash-webapp
mv /opt/crowd/apache-tomcat/conf/Catalina/localhost /opt/crowd/webapps
mkdir /opt/crowd/apache-tomcat/conf/Catalina/localhost

chown -R crowd:atlassian /opt/crowd
