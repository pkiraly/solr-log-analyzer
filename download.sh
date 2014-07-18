#!/bin/bash
USER=euadmin
HOST=-prd-vh.europeana.vancis.nl
PATH=/solr/logs
for date in '07-07' '07-08' '07-09' '07-10' '07-11' '07-12' '07-13' '07-14' '07-15' '07-16' '07-17'
do
	for server in 10 11 12 13
	do
		DOMAIN=solr$server
		FILE=catalina.2014-$date.log
		rsync -avPz $USER@$DOMAIN$HOST:$PATH/$FILE logfiles/$DOMAIN-$FILE
	done
done
