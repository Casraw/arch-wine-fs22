#!/bin/bash

# exit script if return code != 0
set -e

exec /usr/bin/supervisord -c /etc/supervisor.conf -n