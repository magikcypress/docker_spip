#!/bin/bash
set -e

# if command starts with an option, prepend apache
if [ "${1:0:1}" = '-' ]; then
	set -- apachectl "$@"
fi

if [ "$1" = 'apachectl' ]; then
	/usr/sbin/apache2ctl start
	# /usr/sbin/apache2ctl -D FOREGROUND
fi

exec "$@"