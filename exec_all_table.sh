#!/bin/sh

CMDNAME=`basename $0`

for LINE in `$1 -e "SHOW TABLES;"`; do
    if expr $LINE : "^Tables_in_" > /dev/null; then
        continue
    fi

    SQL=$(printf "$2" $LINE)
    $1 -e "$SQL"
done
