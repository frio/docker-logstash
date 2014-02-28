#!/bin/bash
CFG=${CFG:-}
ES_HOST=${ES_PORT_9200_TCP_ADDR:-127.0.0.1}
ES_PORT=${ES_PORT_9200_TCP_PORT:-9200}

if [ "$CFG" != "" ]; then
    curl $CFG -o /etc/logstash/conf.d/logstash.conf --no-check-certificate
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
  stdout { debug => true debug_format => "json"}
  elasticsearch_http { host => "$ES_HOST" port => $ES_PORT }
}
EOF
fi

/usr/bin/java -jar /opt/logstash/logstash.jar agent -f /etc/logstash/conf.d/ -- web
