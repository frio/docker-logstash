#!/bin/bash
CFG=${CFG:-}
ES_HOST=${ES_PORT_9200_TCP_ADDR:-127.0.0.1}
ES_PORT=${ES_PORT_9200_TCP_PORT:-9200}

if [ "$CFG" != "" ]; then
    echo "Grabbing config from $CFG"
    curl $CFG -o /etc/logstash/conf.d/logstash.conf
else
    cat << EOF > /etc/logstash/conf.d/logstash.conf
input {
  syslog {
    type => syslog
    port => 514
  }
  stdin {
    type => example
  }
}
output {
  stdout { }
  elasticsearch { 
    host => "$ES_HOST" 
	port => $ES_PORT
  }
}
EOF
fi

/opt/logstash/bin/logstash agent -f /etc/logstash/conf.d/ -- web

