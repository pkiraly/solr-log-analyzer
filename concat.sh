#!/bin/bash
rm -rf solr-log-entries.csv
cat header.csv >> solr-log-entries.csv
for file in logfiles/*.log.txt
do
	cat $file >> solr-log-entries.csv
done
