# Basics
#
FROM graywolf/jdk-base
MAINTAINER Sergii Gulenok <graywolfs@gmail.com>

# Install Confluence

ENV CONFLUENCE_VERSION 5.8.9
ENV CONTEXT_PATH ROOT
ADD launch.bash /launch
ADD provision.bash /provision

RUN ["/provision"]

# Launching Confluence

WORKDIR /opt/confluence
VOLUME ["/opt/atlassian-home"]
EXPOSE 8090
USER confluence
CMD ["/launch"]
