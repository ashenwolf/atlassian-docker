POSTGRES_USER=postgres
POSTGRES_PASSWORD=${POSTGRES_USER:-postgres}

LOGIN_BASE_URL=http://albert.skoll.com.ua:8095/
CROWD_URL=${LOGIN_BASE_URL}/crowd
CROWD_DB=${CROWD_DB:-crowddb}
CROWD_USER=${CROWD_USER:-crowddbusr}
CROWD_PASS=${CROWD_PASS:-jellyfish}

JIRA_DB=${JIRA_DB:-jiradb}
JIRA_USER=${JIRA_USER:-jiradbuser}
JIRA_PASS=${JIRA_PASS:-jellyfish}

CONFLUENCE_DB=${CONFLUENCE_DB:-confdb}
CONFLUENCE_USER=${CONFLUENCE_USER:-confdbuser}
CONFLUENCE_PASS=${CONFLUENCE_PASS:-jellyfish}

if [ "$(docker run busybox echo 'test')" != "test" ]; then
  SUDO=sudo
  if [ "$($SUDO docker run busybox echo 'test')" != "test" ]; then
    echo "Could not run docker"
    exit 1
  fi
fi

cd "$(dirname $0)"

# JDK base

$SUDO docker build -t graywolf/jdk-base jdk-base

# Postgres

$SUDO docker pull postgres:9.4
$SUDO docker run -d --name postgres -p=5432:5432 -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD postgres:9.4
cat init_db.sh | $SUDO docker run --rm -i --link postgres:db -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD postgres bash -

# Crowd

$SUDO docker build -t graywolf/crowd crowd
CROWD_VERSION="$($SUDO docker run --rm graywolf/crowd sh -c 'echo $CROWD_VERSION')"
$SUDO docker tag graywolf/crowd graywolf/crowd:$CROWD_VERSION
cat init_db_user.sh | $SUDO docker run --rm -i --link postgres:db -e DB_USER=$POSTGRES_USER -e DB_PASS=$POSTGRES_PASSWORD -e APP_DB=$CROWD_DB -e APP_USER=$CROWD_USER -e APP_PASS=$CROWD_PASS postgres bash -
$SUDO docker run -d --name crowd --link postgres:db -e CROWDDB_URL=postgresql://${CROWD_USER}:${CROWD_PASS}@db/${CROWD_DB} -e LOGIN_BASE_URL=$LOGIN_BASE_URL -e CROWD_URL=$CROWD_URL -p 8095:8095 graywolf/crowd

# Jira

$SUDO docker build -t graywolf/jira jira
JIRA_VERSION="$($SUDO docker run --rm graywolf/jira sh -c 'echo $JIRA_VERSION')"
$SUDO docker tag graywolf/jira graywolf/jira:$JIRA_VERSION
cat init_db_user.sh | $SUDO docker run --rm -i --link postgres:db -e DB_USER=$POSTGRES_USER -e DB_PASS=$POSTGRES_PASSWORD -e APP_DB=$JIRA_DB -e APP_USER=$JIRA_USER -e APP_PASS=$JIRA_PASS postgres bash -
$SUDO docker run -d --name jira --link postgres:db -e DATABASE_URL=postgresql://${JIRA_USER}:${JIRA_PASS}@db/${JIRA_DB} -p 8080:8080 graywolf/jira


# Confluence

$SUDO docker build -t graywolf/confluence confluence
CONFLUENCE_VERSION="$($SUDO docker run --rm graywolf/confluence sh -c 'echo $CONFLUENCE_VERSION')"
$SUDO docker tag graywolf/confluence graywolf/confluence:$CONFLUENCE_VERSION
cat init_db_user.sh | $SUDO docker run --rm -i --link postgres:db -e DB_USER=$POSTGRES_USER -e DB_PASS=$POSTGRES_PASSWORD -e APP_DB=$CONFLUENCE_DB -e APP_USER=$CONFLUENCE_USER -e APP_PASS=$CONFLUENCE_PASS postgres bash -
$SUDO docker run -d --name confluence --link postgres:db -e DATABASE_URL=postgresql://${CONFLUENCE_USER}:${CONFLUENCE_PASS}@db/${CONFLUENCE_DB} -p 8090:8090 graywolf/confluence

# Post-setup control

echo "Containers running..."
$SUDO docker ps

echo "IP Addresses of containers:"
$SUDO docker inspect -f '{{ .Config.Hostname }} {{ .Config.Image }} {{ .NetworkSettings.IPAddress }}' postgres crowd jira confluence

