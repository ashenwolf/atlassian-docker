# Basics
#
FROM graywolf/jdk-base:latest
MAINTAINER Sergii Gulenok <graywolfs@gmail.com>

# Install Confluence

ARG CONFLUENCE_VERSION=5.9.5
ENV CONFLUENCE_VERSION ${CONFLUENCE_VERSION}
ENV CONTEXT_PATH ROOT
ADD launch.bash /launch
ADD provision.bash /provision

RUN ["/provision"]

# Launching Confluence

WORKDIR /opt/confluence
EXPOSE 8090
USER confluence
CMD ["/launch"]
