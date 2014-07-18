#!/bin/bash
rm -rf qtimes.txt
for file in logfiles/*-06-2[789].log
do
    rm -rf $file.log.txt
	egrep -B1 "QTime=[0-9]+" $file > qtimes.txt
	perl  -w liner.pl $file qtimes.txt
done
# rm -rf qtimes.txt
