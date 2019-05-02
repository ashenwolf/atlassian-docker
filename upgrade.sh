#!/bin/bash
. settings/settings.sh

CROWD_VERSION=2.8.3
JIRA_VERSION=8.1.0
CONFLUENCE_VERSION=6.8.1

if [ "$(docker run --rm busybox echo 'test')" != "test" ]; then
  SUDO=sudo
  if [ "$($SUDO docker run --rm busybox echo 'test')" != "test" ]; then
    echo "Could not run docker"
    exit 1
  fi
fi

cd "$(dirname $0)"

install_target() {
# JDK base
if [ $1 = "jdk" ]; then
  $SUDO docker build -t graywolf/jdk-base:v3 jdk-base
  $SUDO docker tag -f graywolf/jdk-base:v3 graywolf/jdk-base:latest
fi

# Crowd
if [ $1 = "crowd" ]; then
  $SUDO docker build -t graywolf/crowd:$CROWD_VERSION --build-arg CROWD_VERSION=${CROWD_VERSION} crowd
  #$SUDO docker stop crowd
  $SUDO docker run -d --name crowd --link postgres:db -e CROWDDB_URL=postgresql://${CROWD_USER}:${CROWD_PASS}@db/${CROWD_DB} -e LOGIN_BASE_URL=$LOGIN_BASE_URL -e CROWD_URL=$CROWD_URL -p 8095:8095 graywolf/crowd
fi

# Jira
if [ $1 = "jira" ]; then 
  $SUDO docker build  --build-arg JIRA_VERSION=$JIRA_VERSION -t graywolf/jira-software:$JIRA_VERSION jira-software
  #$SUDO docker stop jira-software
  $SUDO docker run -d --name jira-software-v2-${JIRA_VERSION} -v /var/opt/atlassian:/opt/atlassian-home --link postgres2:db -e DATABASE_URL=postgresql://${JIRA_USER}:${JIRA_PASS}@db/${JIRA_DB} -p 8080:8080 graywolf/jira-software:$JIRA_VERSION
fi

# Confluence
if [ $1 = "confluence" ]; then
  $SUDO docker build -t graywolf/confluence:$CONFLUENCE_VERSION --build-arg CONFLUENCE_VERSION=${CONFLUENCE_VERSION} confluence
  #$SUDO docker stop confluence
  $SUDO docker run -d --name confluence-v2-${CONFLUENCE_VERSION} -v /var/opt/atlassian:/opt/atlassian-home --link postgres2:db -e DATABASE_URL=postgresql://${CONFLUENCE_USER}:${CONFLUENCE_PASS}@db/${CONFLUENCE_DB} -p 8090:8090 graywolf/confluence:$CONFLUENCE_VERSION
fi
}

for TARGET in "$@"
do
  install_target $TARGET
done

# Post-setup control

echo "Containers running..."
$SUDO docker ps -a

echo "IP Addresses of containers:"
$SUDO docker inspect -f '{{ .Config.Hostname }} {{ .Config.Image }} {{ .NetworkSettings.IPAddress }}' postgres crowd jira confluence

