# Basics
#
FROM graywolf/jdk-base:latest
MAINTAINER Sergii Gulenok <graywolfs@gmail.com>

# Install Jira

ARG JIRA_VERSION=7.1.0
ENV JIRA_VERSION ${JIRA_VERSION}
ENV CONTEXT_PATH ROOT
ADD launch.bash /launch
ADD provision.bash /provision

RUN ["/provision"]

# Launching Jira

WORKDIR /opt/jira
#VOLUME ["/opt/atlassian-home"]
EXPOSE 8080
USER jira
CMD ["/launch"]
