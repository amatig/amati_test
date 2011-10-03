#!/bin/sh

files="/cmsbackup/cms/*"

for i in $files
do
    d=`date +%F-%H-%M-%S`
    base=`basename $i`
    mv -f $i "/store/$base.$d"
done

num=12

let "tot=`ls /store -lrt | grep -v total | wc -l`-$num"
files=`ls /store -lrt | grep -v total | head -$tot | awk '{print $9}'`

for i in $files
do
    rm -f "/store/$i"
done
