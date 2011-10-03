#!/bin/bash

wget --save-cookies ./kw --post-data "backurl=http://www.extra.kataweb.it/provisioning/ctrlprovis/?servizio=login&main_errorLoginPage=/jsp/login/gazzettadimantova/login.jsp&Action=SetCookieSSO&giornale=gazzettadimantova&op=login&service=kwextra&errorpage=http://www.extra.kataweb.it/provisioning/ctrlprovis/&userid=mantova9544&userpw=MANTOVA57&invia=ENTRA" -O - http://login.kataweb.it/login/SSO > index.html
#echo "Inserire link:"
#read link
#wget -c --load-cookies ./kw $link