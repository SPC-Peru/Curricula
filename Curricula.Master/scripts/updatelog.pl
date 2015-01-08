#!/usr/bin/perl -w
use strict;
use scripts::Lib::Common;

my $msg    = shift or die "There is no message\n";
my $logfile        = "$Lib::Common::LogDir/$Lib::Common::LogFile";

sub update_log()
{
	if(not -e "$logfile")
	{	open(OUT, ">$logfile");
		close (OUT);
	}
	open(OUT, ">>$logfile") or die "Error abriendo $logfile\n";
	print OUT "$msg\n";
	close (OUT);
}

sub main()
{
	update_log();
	print "Fin updatelog script...\n"
}

main();