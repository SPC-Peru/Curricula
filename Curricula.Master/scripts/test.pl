#!/usr/bin/perl -w
use strict;
use scripts::Lib::Common;

my $txt = Util::read_file("in/tex/CS/CS-Main.tex");

$txt =~ s/\\%/\\PORCENTAGE/g;
$txt =~ s/%.*?\n//g;
$txt =~ s/\\PORCENTAGE/\\%/g;

Util::write_file("temp/CS-Main.tex", $txt);
1;