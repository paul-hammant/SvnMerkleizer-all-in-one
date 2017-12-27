FROM openjdk:8-jre-alpine
MAINTAINER Paul Hammant <paul@hammant.org>

RUN apk --no-cache add apache2 apache2-proxy apache2-utils apache2-webdav mod_dav_svn subversion
ADD vh-davsvn.conf /etc/apache2/conf.d/
ADD authz.authz /etc/apache2/conf.d/

RUN mkdir -p /run/apache2

EXPOSE 80

ADD svnmerkleizer-1.0-SNAPSHOT.jar /usr/share/myservice/svnmerkleizer.jar

ADD wrapper_script.sh /
RUN chmod +x /wrapper_script.sh

CMD /wrapper_script.sh
