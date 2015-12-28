#!/bin/bash
/etc/init.d/mysql start
/usr/sbin/apache2ctl start
# /usr/sbin/apache2ctl -D FOREGROUND