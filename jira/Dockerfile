# Basics
#
FROM graywolf/jdk-base
MAINTAINER Sergii Gulenok <graywolfs@gmail.com>

# Install Jira

ENV JIRA_VERSION 6.4.10
ENV CONTEXT_PATH ROOT
ADD launch.bash /launch
ADD provision.bash /provision

RUN ["/provision"]

# Launching Jira

WORKDIR /opt/jira
VOLUME ["/opt/atlassian-home"]
EXPOSE 8080
USER jira
CMD ["/launch"]
