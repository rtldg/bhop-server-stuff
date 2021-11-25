#!/bin/sh
ln -fs /var/run/mysqld/mysqld.sock /tmp/mysql.sock
#LD_LIBRARYPATH="$PWD/../linux32/:$LD_LIBRARY_PATH"
./srcds_run -insecure -port 27016 +tv_port 27021 -clientport 27006 -console -tickrate 100 +sv_lan 1 -game cstrike +map bhop_freedompuppies
