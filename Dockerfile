FROM frio/openjdk-7-jre

MAINTAINER Arcus "http://arcus.io"
MAINTAINER frio "http://frio.name"

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install curl

RUN curl https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.3.3-1-debian_all.deb -o /tmp/logstash_1.3.3-1-debian_all.deb
RUN dpkg -i /tmp/logstash_1.3.3-1-debian_all.deb
RUN rm -rf /tmp/*

ADD run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 514
EXPOSE 9292

ENTRYPOINT /run.sh
