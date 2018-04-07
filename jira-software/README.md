# Jira Docker image

This folder contains the Dockerfile and associated files for the ```durdn/atlassian-jira``` docker image which aims to make it a breeze getting an Atlassian Jira instance up and running.

## Using Docker Compose to run the published image (Recommended)
This will provision a local PostgreSQL DB container, download the `atlassian-jira`
image from the public Docker Hub, and start a locally running instance of JIRA.

1. Install Docker (http://docs.docker.com/installation/)
2. Install Docker Compose (http://docs.docker.com/compose/)
3. From this directory, run `docker-compose up`
4. After a few moments, JIRA should now be running locally on http://localhost:8080

## Using Docker Compose to build and run the Dockerfile (for developing the image)
This will provision a local PostgreSQL DB container, build the `atlassian-jira`
image from the Dockerfile, and start a locally running instance of JIRA. It's
meant to be used when you are contributing to the Dockerfile or don't have
access to the public Docker Hub.

1. Install Docker (http://docs.docker.com/installation/)
2. Install Docker Compose (http://docs.docker.com/compose/)
3. From this directory, run `docker-compose -f docker-compose-dev.yml up`
4. After a few minutes, JIRA should now be running locally on http://localhost:8080

## Database connection

The connection to the database can be specified with an URL of the format:
```
[database type]://[username]:[password]@[host]:[port]/[database name]
```
Where ```database type``` is either ```mysql``` or ```postgresql``` and the full URL might look like this:
```
postgresql://jira:jellyfish@172.17.0.2/jiradb
```

When a database url is specified Jira will skip the database configuration step in the setup.

## Configuration

Configuration options are set by setting environment variables when running the image. What follows it a table of the supported variables:

Variable     | Function
-------------|------------------------------
CONTEXT_PATH | Context path of the jira webapp. You can set this to add a path prefix to the url used to access the webapp. i.e. setting this to ```jira``` will change the url to http://localhost:8080/jira/. The value ```ROOT``` is reserved to mean that you don't want a context path prefix. Defaults to ```ROOT```
DATABASE_URL | Connection URL specifying where and how to connect to a database dedicated to jira. This variable is optional and if specified will cause the Jira setup wizard to skip the database setup set.
