## Licensed to the Apache Software Foundation (ASF) under one or more
## contributor license agreements.  See the NOTICE file distributed with
## this work for additional information regarding copyright ownership.
## The ASF licenses this file to You under the Apache License, Version 2.0
## (the "License"); you may not use this file except in compliance with
## the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
## 
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

## Apache Jena Fuseki server Dockerfile.

FROM openjdk:8
LABEL maintainer="The Apache Jena community <users@jena.apache.org>"

ARG VERSION=3.13.0

## Where to get the bytes
ENV REPO=https://repository.apache.org/content/repositories/releases/
##ENV REPO=http://central.maven.org/maven2/
ENV JAR_URL=$REPO/org/apache/jena/jena-fuseki-server/${VERSION}/jena-fuseki-server-${VERSION}.jar

## Fuseki file area.
ARG BASE=/var/fuseki
ENV BASE=$BASE
ARG DATA=$BASE/data
ENV DATA=$DATA
ARG RUN=$BASE
ENV RUN=$RUN
ARG LOG=$BASE/log
ARG INIT_D=$BASE/init.d
ENV INIT_D=$INIT_D

RUN mkdir -p $BASE   && \
    mkdir -p $DATA   && \
    mkdir -p $LOG    && \
    mkdir -p $INIT_D && \
    cd $BASE && \
    curl -s --show-error --output fuseki-server.jar $JAR_URL

## External file space.
VOLUME $DATA
VOLUME $LOG

## Fixed - use -p (-publish) to map ports e.g. -p 8080:3030
EXPOSE 3030

# Place choices of "log4j.properties" in the build directory
# Ensure log destinations align.
COPY log4j.properties /var/fuseki/log4j.properties
COPY entrypoint.sh /var/fuseki/entrypoint.sh

WORKDIR $RUN

RUN chmod +x entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]

## Command line arguments are those for Fuseki.
CMD []