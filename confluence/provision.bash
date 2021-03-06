#!/bin/bash
set -e

CONF_INSTALL=/opt/confluence

echo Downloading unzip
DEBIAN_FRONTEND=noninteractive apt-get install -q -y unzip

echo Downloading Confluence $CONFLUENCE_VERSION
#curl -Lks http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz -o /root/confluence.tar.gz
curl -Lks https://product-downloads.atlassian.com/software/confluence/downloads/atlassian-confluence-${CONFLUENCE_VERSION}.zip -o /root/confluence.zip
/usr/sbin/useradd --create-home --home-dir ${CONF_INSTALL} --groups atlassian --shell /bin/bash confluence
#tar zxf /root/confluence.tar.gz --strip=1 -C ${CONF_INSTALL}
ln -s /opt/confluence /opt/confluence/atlassian-confluence-${CONFLUENCE_VERSION} # create a symlink that redirects output
unzip -a /root/confluence.zip -d /opt/confluence
rm /opt/confluence/atlassian-confluence-${CONFLUENCE_VERSION} # remote symlink
rm /root/confluence.zip
echo "confluence.home = /opt/atlassian-home/confluence" > ${CONF_INSTALL}/confluence/WEB-INF/classes/confluence-init.properties
chown -R confluence:atlassian ${CONF_INSTALL}

chmod -R 700                   "${CONF_INSTALL}/conf"
chmod -R 700                   "${CONF_INSTALL}/temp"
chmod -R 700                   "${CONF_INSTALL}/logs"
chmod -R 700                   "${CONF_INSTALL}/work"

mv ${CONF_INSTALL}/conf/server.xml ${CONF_INSTALL}/conf/server-backup.xml

