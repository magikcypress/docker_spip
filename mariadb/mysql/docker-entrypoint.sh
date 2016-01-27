#!/bin/bash
set -e

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
	set -- mysqld "$@"
fi

if [ "$1" = 'mysqld' ]; then
	# Get config
	DATADIR="$("$@" --verbose --help 2>/dev/null | awk '$1 == "datadir" { print $2; exit }')"

	if [ ! "$(ls -A ${DATADIR})" ]; then
	  USER="container"
	  PASSWORD="$(pwgen -1 32)"

	  mysql_install_db --user="mysql" > /dev/null 2>&1
	  mysqld_safe > /dev/null 2>&1 &

	  TIMEOUT=30

	  while ! mysqladmin -u root status > /dev/null 2>&1
	  do
	    TIMEOUT=$((${TIMEOUT} - 1))

	    if [ ${TIMEOUT} -eq 0 ]; then
	      exit 1
	    fi

	    sleep 1
	  done

	  mysql -u root -e "CREATE USER 'root'@'%' IDENTIFIED BY '${PASSWORD}';"
	  mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
	  mysql -u root -e "RENAME USER 'root' TO '${USER}';"

	  mysqladmin -u "${USER}" -p"${PASSWORD}" shutdown
	fi

	chown -R mysql:mysql "$DATADIR"
fi

exec "$@"