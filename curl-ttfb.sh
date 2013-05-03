#!/bin/bash
#
# Report time to first byte for the provided URL using a cache buster to ensure
# that we're measuring full cold-cache performance

for i in `seq 1 $1`; do
    echo $3
    curl -so /dev/null -H "Pragma: no-cache" -H "Cache-Control: no-cache" \
        -w "%{http_code}\tPre-Transfer: %{time_pretransfer}\tStart Transfer: %{time_starttransfer}\tTotal: %{time_total}\tSize: %{size_download}\n" \
        $3 -X $2 -d $4
done
