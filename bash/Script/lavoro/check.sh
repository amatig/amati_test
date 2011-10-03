#!/bin/bash

HOST=192.168.64.228
NUM=3

SPATH=`dirname $0`
COUNTER=$SPATH/counter

if [ ! -f $COUNTER ] ; then
    echo 0 > $COUNTER
fi

if ! ping -c 1 -w 5 $HOST &>/dev/null ; then
    TICK=`cat $COUNTER`
    let "TICK += 1"
    echo $TICK > $COUNTER
    
    if [ "$TICK" -eq "$NUM" ]; then
	/etc/init.d/sshd restart
	#/etc/init.d/sshd start
    fi
else
    echo 0 > $COUNTER
fi