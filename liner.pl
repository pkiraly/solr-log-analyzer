use strict;
use warnings;
use JSON;

sub dateFixer {
	my $hour = shift;
	my $am = shift;

	my $number = '';
	if ($hour eq '12') {
		if ($am eq 'AM') {
			$number = '00';
		} else {
			$number = '12';
		}
	} elsif ($am eq 'PM') {
		$number = $hour + 12;
	} elsif (length($hour) == 1) {
		$number = '0' . $hour;
	} else {
		$number = $hour;
	}
	# print STDERR $hour, $am, '->', $number, "\n";

	$number .= ',';
	return $number;
}

my $fileName = shift;
my $file = shift;

print $fileName, "\n";
my $server = '';
if ($fileName =~ m/^(solr\d+)-/) {
	$server = $1;
}
my $out = $fileName;
$out =~ s/\.log/.log.txt/;
print $out, "\n";
open(LOG, $file) || die "Can't open $file: $!\n";
open(TXT, '>' . $out) || die "Can't open $file: $!\n";
my $line = '';
my $original = '';
my $hits = 0;
while (<LOG>) {
	next unless (/^(May|Jun).* org.apache.solr.core.SolrCore execute/ || /INFO: \[search\] webapp=\/solr/ );

	my $isFirstPage = 0;

	if (/^(May|Jun)/) {
		$isFirstPage = 1;
		$line = '';
		$hits = 0;
		$original = $_;
	} else {
		$original .= $_;
	}
	s/org.apache.solr.core.SolrCore execute//;
	s/INFO://;
	s/ webapp=\/solr//;
	s/ path=\/(select|search|suggest(Who|What|Where|When|Title)|admin\/(luke|system|ping|file\/))//;
	s/ \[search\]//;
	s/^May/05/;
	s/^Jun/06/;
	s/^(0[56]) (\d),/$1 0$2,/;
	s/^(0[56]) (\d\d),/"$1-$2",/;
	s/ 2014 (\d+):\d\d:\d\d ([AP]M)/dateFixer($1, $2)/e;
	s/\s*params=.*?\} / /;
	if (/ hits=(\d+)/) {
		$hits = $1;
		s/ hits=(\d+)//;
	}
	s/ status=(\d+)/$1,/;
	s/ QTime=(\d+)/$1/;
	s/^\s+|\s+$//g;
	if ($isFirstPage == 1) {
		$line = '"' . $server . '",';
	}
	$line .= $_;
	if ($isFirstPage == 0) {
		$line .= ',' . $hits;
		my @count = $line =~ /,/g;
		my $count = scalar @count;
		print STDERR $count, ' -> ', $line, "\n", $original, "\n" if ($count != 5);
		if ($line =~ m/,.+([a-z]+)/) {
			print STDERR $1, ' as w in ', $line, "\n", $original, "\n" 
		}
		print TXT $line, "\n";
	}
}
close(TXT);
close(LOG);

