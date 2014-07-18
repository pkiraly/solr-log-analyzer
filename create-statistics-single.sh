file=solr10-catalina.2014-06-06.log
#egrep -B1 "QTime=[0-9]+" $file > qtimes.txt
perl  -w liner.pl $file qtimes.txt
