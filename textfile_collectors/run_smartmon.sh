#!/bin/bash

while true
    do
        cd /home/thunder/media_server/textfile_collectors/
        ./smartmon.sh > /textfile_collector_result/smartmon.tmp
        mv /textfile_collector_result/smartmon.tmp /textfile_collector_result/smartmon.prom
        sleep 30
    done
