use strict;
use warnings;

# my $file = shift;
my @files = <"*.log">;
foreach my $file (@files) {
	print $file, "\n";
	my $server = '';
	if ($file =~ m/^solr(\d+)-/) {
		$server = $1;
	}
	my $out = $file;
	$out =~ s/\.log/.log.txt/;
	print $out, "\n";
	open(LOG, $file) || die "Can't open $file: $!\n";
	open(TXT, '>' . $out) || die "Can't open $file: $!\n";
	while (<LOG>) {
		next unless (/^(May|Jun).* org.apache.solr.core.SolrCore execute/ || /INFO: \[search\] webapp=\/solr/ );

		my $isFirstPage = 0;

		if (/^(May|Jun)/) {
			$isFirstPage = 1;
		}
		s/org.apache.solr.core.SolrCore execute//;
		s/INFO://;
		s/&wt=javabin//;
		s/&rows=\d+//;
		s/&version=\d//;
		s/ webapp=\/solr//;
		s/ path=\/select//;
		s/ \[search\]//;
		s/&timeAllowed=30000//;
		s/\&sort=score\+desc//;
		s/\{sort=score\+desc/\{/;
		s/&start=\d+//;
		s/^May/05/;
		s/^Jun/06/;
		s/^(0[56]) (\d),/$1 0$2,/;
		s/^(0[56]) (\d\d),/$1,$2,/;
		s/2014 (\d+)(:\d\d:\d\d PM)/'2014 ' . (12 + $1) . $2/e;
		s/2014 (\d:\d\d:\d\d AM)/2014 0$1/;
		s/2014 12(:\d\d:\d\d AM)/2014 00$1/;
		s/ 2014 (\d\d):\d\d:\d\d [AP]M/$1,/;
		s/facet\.query=(.*?)&//g;
		s/facet\.mincount=\d+&//g;
		s/facet\.limit=\d+&//g;
		s/facet\.field=.*?&//g;
		s/facet\.field=.*?}/}/g;
		s/facet=true//g;
		s/\s*params=.*?\} / /;
		s/ hits=(\d+)/$1,/;
		s/ status=(\d+)/$1,/;
		s/ QTime=(\d+)/$1/;
		s/^\s+|\s+$//g;
		if ($isFirstPage == 1) {
			print TXT $server, ",";
		}
		print TXT $_;
		if ($isFirstPage == 0) {
			print TXT "\n";
		}
	}
	close(TXT);
	close(LOG);
}
