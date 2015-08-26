# Basics
#
FROM ubuntu:14.04
MAINTAINER Sergii Gulenok <graywolfs@gmail.com>
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y git-core curl sudo xmlstarlet \
  software-properties-common python-software-properties

# Install Java 8

RUN DEBIAN_FRONTEND=noninteractive apt-add-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get install oracle-java8-installer -y

RUN DEBIAN_FRONTEND=noninteractive apt-get clean
RUN DEBIAN_FRONTEND=noninteractive apt-get autoclean
RUN DEBIAN_FRONTEND=noninteractive apt-get autoremove

# Setup volume handling
RUN /usr/sbin/groupadd atlassian
ADD own-volume.sh /usr/local/bin/own-volume
RUN echo "%atlassian ALL=NOPASSWD: /usr/local/bin/own-volume" >> /etc/sudoers
RUN mkdir -p /opt/atlassian-home

# Add common script functions
ADD common.bash /usr/local/share/atlassian/common.bash
RUN chgrp atlassian /usr/local/share/atlassian/common.bash
RUN chmod g+w /usr/local/share/atlassian/common.bash

RUN openssl s_client -connect marketplace.atlassian.com:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > marketplace.atlassian.com.crt
RUN openssl s_client -connect plugins.atlassian.com:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > plugins.atlassian.com.crt
RUN openssl s_client -connect dq1dnt4af4eyy.cloudfront.net:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > dq1dnt4af4eyy.cloudfront.net.crt
RUN openssl s_client -starttls smtp -crlf -connect smtp.gmail.com:587 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > smtp.gmail.com.crt

RUN keytool -importcert -storepass changeit -alias marketplace.atlassian.com:443 -keystore $JAVA_HOME/jre/lib/security/cacerts -file marketplace.atlassian.com.crt -noprompt
RUN keytool -importcert -storepass changeit alias plugins.atlassian.com:443 -keystore $JAVA_HOME/jre/lib/security/cacerts -file plugins.atlassian.com.crt -noprompt
RUN keytool -importcert -storepass changeit -alias dq1dnt4af4eyy.cloudfront.net:443 -keystore $JAVA_HOME/jre/lib/security/cacerts -file dq1dnt4af4eyy.cloudfront.net.crt -noprompt
RUN keytool -importcert -storepass changeit -alias smtp.gmail.com:587 -keystore $JAVA_HOME/jre/lib/security/cacerts -file smtp.gmail.com.crt -noprompt


