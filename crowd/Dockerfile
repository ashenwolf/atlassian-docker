# Basics
#
FROM graywolf/jdk-base
MAINTAINER Sergii Gulenok <graywolfs@gmail.com>

# Install Crowd

ENV CROWD_VERSION 2.8.3
ENV SPLASH_CONTEXT ROOT

ADD launch.bash /launch
ADD provision.bash /provision

RUN ["/provision"]

ENV CROWD_URL http://localhost:8095/crowd
ENV LOGIN_BASE_URL http://localhost:8095

ENV CROWD_CONTEXT crowd
ENV CROWDID_CONTEXT openidserver
ENV OPENID_CLIENT_CONTEXT openidclient
ENV DEMO_CONTEXT demo

ADD splash-context.xml /opt/crowd/webapps/splash.xml

# Launching Crowd

VOLUME /opt/atlassian-home
WORKDIR /opt/crowd
EXPOSE 8095
USER crowd
CMD ["/launch"]
