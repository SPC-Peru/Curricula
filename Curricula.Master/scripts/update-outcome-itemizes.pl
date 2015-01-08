#!/usr/bin/perl -w
use scripts::Lib::Common;
use strict;

if( defined($ENV{'CurriculaParam'}))	{ $Common::command = $ENV{'CurriculaParam'};	}
if(defined($ARGV[0])) { $Common::command = shift or Util::halt("There is no command to process (i.e. AREA-INST)");	}

sub replace_outcomes()
{
	my $file = Common::get_template("in-all-outcomes-by-course-poster");
	my $all_outcomes_txt = Util::read_file($file);
	while( $all_outcomes_txt =~ m/\\ref{out:Outcome(.*?)}/g )
	{
	      my $outcome = $1;
	      if( defined($Common::config{outcomes_map}{$outcome}) )
	      {		$all_outcomes_txt =~ s/\\ref{out:Outcome$outcome}/ $Common::config{outcomes_map}{$outcome}/g;	}
	      else
	      {		Util::print_message("Outcome config{outcomes_map}{$outcome} not defined ... did you compile the curricula.tex???? ");	}
	}
	Util::write_file($file, $all_outcomes_txt);
	Util::print_message("replace_outcomes() OK!");
}

sub main()
{
	Common::set_initial_configuration($Common::command);
        Common::read_pagerefs();
	replace_outcomes();
}

main();