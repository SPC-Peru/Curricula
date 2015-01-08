#!/usr/bin/perl -w
use scripts::Lib::Common;
use strict;

my $file = "";
if( defined($ENV{'CurriculaParam'}))	{ $Common::command = $ENV{'CurriculaParam'};	}
if(defined($ARGV[0])) { $Common::command = shift or Util::halt("There is no command to process (i.e. AREA-INST)");	}

sub update_page_numbers_for_all_courses_maps()
{
	my $OutputDotDir  		= Common::get_template("OutputDotDir");
	for(my $semester = $Common::config{SemMin}; $semester <= $Common::config{SemMax} ; $semester++)
	{
		foreach my $codcour (@{$Common::courses_by_semester{$semester}})
		{
			my $output_file = "$OutputDotDir/$codcour.dot";
			Common::update_page_numbers($output_file);
		}
	 }
}

sub main()
{
	Common::set_initial_configuration($Common::command);
        Common::read_pagerefs();
	Common::parse_courses(); 
        Common::filter_courses();
	
	Common::update_page_numbers(Common::get_template("out-big-graph-curricula-dot-file"));
	update_page_numbers_for_all_courses_maps();	
}

main();