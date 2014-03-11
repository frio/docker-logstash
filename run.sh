#!/bin/bash
CFG=${CFG:-}

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
  elasticsearch { embedded => true }
}
EOF
fi

/opt/logstash/bin/logstash agent -f /etc/logstash/conf.d/ -- web
