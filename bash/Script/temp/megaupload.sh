#!/bin/bash

wget --save-cookies ./megaupload --post-data "login=1&next=c%3Daccount&username=amatig80&password=vito" -O - http://www.megaupload.com/?c=account > /dev/null

wget -c --load-cookies ./megaupload -i lista.txt