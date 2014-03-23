#!/usr/bin/env python
from string import Template
import os
import subprocess
import sys
import urllib2

LOGSTASH_CMD = '/opt/logstash/bin/logstash agent -f /etc/logstash/conf.d/ -- web'
CONFIG_FILE_LOCATION = os.path.join('/', 'etc', 'logstash', 'conf.d', 'logstash.conf')
DEMO_CONFIG = '''
input {
  stdin {
    type => example
  }
}
output {
  stdout { }
}
'''

try:
    config_source = os.environ['CFG']
    config = urllib2.urlopen(config_source).read()
except KeyError as e:
    config = DEMO_CONFIG

# Subsitute in strings that need replacing from the ENV
# This lets you put stuff like, for instance, %{ELASTICSEARCH_HOST} in your config
config = Template(config).substitute(os.environ)

with open(CONFIG_FILE_LOCATION, 'w') as fh:
    fh.write(config)

subprocess.call(LOGSTASH_CMD, shell=True, stdin=sys.stdin, stdout=sys.stdout, stderr=sys.stderr)
