# atlassian-docker
Docker scripts to set up Atlassian tools in a docker containers

## What is it?

It is a collection of scripts for me to make one-click installation of Atlassian Jira, Confluence and Crowd instances via docker.

## Quick set up

Clone the repository on the target system:

    $ git clone ...

The run the main script for installation:

    $ setup.sh crowd jira confluence

Where ```crowd```, ```jira```, ```confluence``` are the tools to be installed. You can pick any of those.

## Containers

### Postgres

A container for PostgreSQL database. Based on the generic ```postgres``` image.

### Data containers

There are 
Data storages for 