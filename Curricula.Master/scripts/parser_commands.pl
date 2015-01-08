#!/usr/bin/perl
#\newcommand{\jose}{hola {xyz} ... {abc} ...}

my $file = shift;
my $texto = &read($file);
my %commands;
while ($texto =~ m/\\newcommand{(.*?)}%?\s*{(.*?)}\n+/gcxs) {
	$commands{$1} = $2;
}

my $cont = 1;
foreach my $tmp (keys(%commands)) {
	print $cont++."\t".$tmp."\t".$commands{$tmp}."\n";
}

sub read {
	my $namefile = shift;
	open(TMP, $namefile);
	my $content = join '', <TMP>;
	close TMP;
	return $content;
}
