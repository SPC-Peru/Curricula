#!/usr/bin/perl -w
use strict;
use scripts::Lib::Common;
#use scripts::Lib::GenSyllabi;
#use scripts::Lib::GeneralInfo;

if( defined($ENV{'CurriculaParam'}))	{ $Common::command = $ENV{'CurriculaParam'};	}
if(defined($ARGV[0])) { $Common::command = shift or Util::halt("There is no command to process (i.e. AREA-INST)");	}

my $script = "";

sub insert_analytic_script($)
{
        my ($file) = (@_);
        my $in = Util::read_file($file);
        $in =~ s/<\/BODY>/$script<\/BODY>/g;
        Util::write_file($file, $in);
}

sub update_html_files()
{
        $script = Util::read_file(Common::get_template("in-analytics.js-file"))."\n";

        my $dir = Common::get_template("OutputHtmlDir");
        opendir DIR, $dir;
        my @filelist = readdir DIR;
        closedir DIR;
        my $count = 0;
        #insert_analytic_script("$dir/node2.html"); exit;
        foreach my $htmlfile (@filelist)
        {
              if($htmlfile =~ m/.*\.html/)
              {
                    print "$dir/$htmlfile ...                            ";
                    insert_analytic_script("$dir/$htmlfile");
                    print "ok ...($count)!                                                                \r";
                    $count++;
              }
        }
        Util::print_message("\nTotal $count files updated ...                                     ");
}

sub main()
{
	Util::begin_time();
	Common::set_initial_configuration($Common::command);
        update_html_files();
	Util::print_time_elapsed();
	Util::print_message("update-analytics-info finished ok ...");
}

main();

