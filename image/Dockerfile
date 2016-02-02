# Copyright 2016 Produban Servicios InformÃ¡ticos Generales S.L.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM centos:7
MAINTAINER Global PaaS global_paas@produban.com

ADD application.jar /

ENV JAVA_VERSION 1.8.0
ENV GID 20000
ENV UID 20000

ENV APP_HOME /opt/app
ENV WILY_HOME /opt/wily
ENV IMAGE_SCRIPTS_HOME /opt/produban

RUN mkdir -p $APP_HOME && \
	mkdir $IMAGE_SCRIPTS_HOME && \
    mkdir -p $IMAGE_SCRIPTS_HOME/certs && \
    mkdir -p $IMAGE_SCRIPTS_HOME/bin && \
    mkdir -p $WILY_HOME/wilyAgent

COPY Dockerfile $IMAGE_SCRIPTS_HOME/Dockerfile
COPY bin $IMAGE_SCRIPTS_HOME/bin

RUN groupadd --gid $GID java && useradd --uid $UID -m -g java java && \
    yum -y install \
       java-$JAVA_VERSION-openjdk-devel \
       procps-ng \
       strace \
       unzip \
       wget && \
    yum clean all

ADD scripts $IMAGE_SCRIPTS_HOME
ADD wilyAgent $WILY_HOME/wilyAgent
ADD certs $IMAGE_SCRIPTS_HOME/certs

RUN chown -R java:java $APP_HOME && \
    chown -R java:java $IMAGE_SCRIPTS_HOME && \
    chown -R java:java $WILY_HOME

RUN cd $IMAGE_SCRIPTS_HOME/certs; ./importCerts.sh
EXPOSE 8080

#######################################################################
##### We have to expose image metada as label and ENV
#######################################################################
LABEL com.produban.imageowner="Products and Services" \
      com.produban.description="Java 8 runtime for Spring boot microservices" \
      com.produban.components="java8, wily Introscope 9.7"

ENV com.produban.imageowner="Products and Services" \
    com.produban.description="Java 8 runtime for Spring boot microservices" \
    com.produban.components="java8, wily Introscope 9.7"

USER java
WORKDIR $IMAGE_SCRIPTS_HOME

ENTRYPOINT [ "./control.sh" ]
CMD [ "start" ]
