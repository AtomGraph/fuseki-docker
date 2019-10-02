# Basic Fuseki Dockerfile.

## To do:
# VOLUME and databases

FROM java:8-jdk

LABEL maintainer="The Apache Jena community <users@jena.apache.org>"

ARG VERSION=3.13.0
ARG SRC=http://central.maven.org/maven2/org/apache/jena/
ARG BINARY=jena-fuseki-server/${VERSION}/jena-fuseki-server-${VERSION}.jar

ENV URL=http://central.maven.org/maven2/org/apache/jena/jena-fuseki-server/${VERSION}/jena-fuseki-server-${VERSION}.jar
ENV BASE=/mnt/apache-fuseki

## VOLUME /mnt/

RUN mkdir -p $BASE

WORKDIR $BASE

RUN curl --silent --show-error --output fuseki-server.jar $URL

EXPOSE 3030

ENTRYPOINT [ "/usr/bin/java", "-jar", "fuseki-server.jar" ]