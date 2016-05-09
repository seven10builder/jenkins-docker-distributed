FROM seven10builder/jenkins-master-base:2.0-alpine
MAINTAINER kmilner@seven10storage.com

USER root
RUN apk add --update py-pip && \
	pip install --upgrade pip &&\
	pip install docker-cloud

USER jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt
# COPY bin/start_slave.sh /usr/local/bin/start_slave.sh

RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt 
#    chmod +x /usr/local/bin/start_slave.sh
USER root
CMD ["/usr/local/bin/setup-docker-and-start-jenkins.sh"]