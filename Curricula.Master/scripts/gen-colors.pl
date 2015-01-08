#!/usr/bin/perl -w
use strict;

my %map = 	("0" => 0,
			 "1" => 1,
			 "2" => 2,
			 "3" => 3,
			 "4" => 4,
			 "5" => 5,
			 "6" => 6,
			 "7" => 7,
			 "8" => 8,
			 "9" => 9,
			 "a" => 10,
			 "b" => 11,
			 "c" => 12,
			 "d" => 13,
			 "e" => 14,
			 "f" => 15
			);
	
sub hex2dec($)
{
    my ($hex) = (@_);
	if( $hex =~ m/(.)(.)/)
	{
		my $num = 16*$map{$1} + $map{$2};
		return $num/255;
	}
	return 0;
}

sub main()
{
	open(IN, "<base-tex/temp.tex") or die "Unable to open";
	while(<IN>)
	{
  		if(m/<td bgcolor=.*><a title=\#(..)(..)(..)>(.*)<\/a><\/td>/)
#  		if(m/bgcolor/)
		{
# 			print "x\n";
			my ($txt1, $txt2, $txt3) = (hex2dec($1), hex2dec($2), hex2dec($3));
			print "\\newrgbcolor{$4}{$txt1 $txt2 $txt3}\n";
		}
	}
}

main();