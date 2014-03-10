FROM frio/openjdk-7-jre:latest

MAINTAINER Arcus "http://arcus.io"
MAINTAINER frio "http://frio.name"

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install curl

# While we're in beta, we can't run the usual .deb installation and have to do stuff manually
RUN curl https://download.elasticsearch.org/logstash/logstash/logstash-1.4.0.beta2.tar.gz -o /tmp/logstash.tar.gz
RUN mkdir /tmp/logstash
RUN tar xf /tmp/logstash.tar.gz -C /tmp/logstash
RUN mv /tmp/logstash/logstash-1.4.0.beta2 /opt/logstash
RUN rm -rf /tmp/*
RUN mkdir -p /etc/logstash/conf.d/

# Also, we'll need to patch up the Logstash install as per LOGSTASH-1918
RUN GEM_HOME=/opt/logstash/vendor/bundle/jruby/1.9 GEM_PATH="" java -jar /opt/logstash/vendor/jar/jruby-complete-1.7.11.jar -S gem install sinatra rack

ADD run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 514
EXPOSE 9292

ENTRYPOINT /run.sh

