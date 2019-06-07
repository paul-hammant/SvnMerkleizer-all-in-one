FROM alpine:3.7

MAINTAINER Paul Hammant <paul@hammant.org>

ENV LANG C.UTF-8

RUN apk add --no-cache bash=4.4.19-r1

RUN apk add --no-cache openjdk8-jre
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $JAVA_HOME/bin:$PATH

RUN apk --no-cache add apache2 apache2-proxy apache2-utils apache2-webdav mod_dav_svn subversion
ADD vh-davsvn.conf /etc/apache2/conf.d/
ADD authz.authz /etc/apache2/conf.d/

RUN mkdir -p /run/apache2

ADD svnmerkleizer-service-1.0-SNAPSHOT.jar /usr/share/myservice/svnmerkleizer.jar

ADD wrapper_script.sh /
RUN chmod +x /wrapper_script.sh

EXPOSE 80

CMD /wrapper_script.sh
