#!/usr/bin/perl -w

use strict;

my $institutions_info_dir = "institutions-info/";
my $inst_map_file         = "$institutions_info_dir"."institutions-map.txt";

my %inst_map = ();
my @params;

sub read_params()
{
	
	push(@params, "");
}

sub parse_map()
{
	my @contents;
	open(IN, "<$inst_map_file") or die "compileall: $inst_map_file no abre \n";
	@contents = <IN>;
	foreach my $line (@contents)
	{
		#print "\"$line\"";
		if($line =~ m/%.*/)
		{	next;	}
		if($line =~ m/\s*(.*)\s*->\s*(.*)\s*/)
		{
			my $inst   = $1;
			my $filter = $2;
			$filter    =~ s/ //g;
			$inst_map{$inst} = $filter;
			#print "\"$inst\":\"$filter\"\n";
		}
	}
	
}

sub process_param($)
{
	my ($this_inst) = (@_);
	my $command = "./compile1institucion $this_inst $inst_map{$this_inst}";
	print "\"$command\"\n";
	system($command);
}

sub process_all_params()
{
	foreach my $inst (keys %inst_map)
	{	#print "\"$inst\"\n";
		process_param($inst);
	}
}

sub update_web_files()
{
	system("scp -P 993 pdfs/cur-main-*.pdf ecuadros\@inf.ucsp.edu.pe:/home/ecuadros/public_html/.");
}

parse_map();
process_all_params();
update_web_files();


