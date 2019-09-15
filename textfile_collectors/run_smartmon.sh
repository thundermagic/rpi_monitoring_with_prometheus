#!/bin/bash

while true
    do
        # Change to the directory where smartmon.sh script is. If you have been using your home directory then it would
        # be what is in the below statement. Please adjust it accordingly else
        cd $HOME/rpi_monitoring_with_prometheus/textfile_collectors
        # Run the script and save the output to file in /textfile_collector_result directory. You would need to have this
        # directory created.
        ./smartmon.sh > /textfile_collector_result/smartmon.tmp
        # Rename the file. node exporter textfile collector parses files with .prom extension
        mv /textfile_collector_result/smartmon.tmp /textfile_collector_result/smartmon.prom
        # Interval at which to measure stats. Change it as per your need. Its in seconds
        sleep 30
    done
