#!/bin/bash
#
# This is a quick, light, network test probe to run from an OSX
# client.  The idea, here, is for this to be very easy for end-users
# to install, run, and make short reports about their
# Application-layer WiFi performance, without needing to install
# anything else.
# 
# Author: Matt Elder <fiddlemath@gmail.com>

LOGFILE=~/Desktop/net-report.txt

iperf () {
    echo
    echo "--- performance ---"
    iperf3 -c 10.1.10.204
    iperf3 -c 10.1.10.204 -u -b 4M
}    

speedtest () {
    echo
    echo "--- speedtest ---"
    if [ ! -e speedtest_cli.py ]
    then
        curl -s -L -o speedtest_cli.py https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest_cli.py
    fi
    python speedtest_cli.py
}

pingtest () {
    ping -c 5 -t 5 -q $1 | grep -v 'PING'
}

netstatus () {
    echo
    echo "=== airport info ==="
    /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I
    echo "--- scan ---"
    /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s
    echo "--- prefs ---"
    /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport prefs
}

netcheck () {
    echo
    echo "=== $(date +'%F %T') ==="
    echo "$*"
    netstatus
    pingtest 10.1.10.204
    pingtest google.com
    iperf
    echo
    echo
}

netcheck | tee -a $LOGFILE

