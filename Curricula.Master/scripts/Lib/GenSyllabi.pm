package GenSyllabi;
use Data::Dumper;
use Scalar::Util qw(blessed dualvar isdual readonly refaddr reftype
                        tainted weaken isweak isvstring looks_like_number
                        set_prototype);
                        # and other useful utils appearing below
use scripts::Lib::Common;
use strict;

sub get_environment($$$)
{
	my ($codcour, $txt, $env) = (@_);

	if($txt =~ m/\\begin{$env}\s*\n((?:.|\n)*)\\end{$env}/g)
	{	return $1;	}
# 	Util::print_warning("$codcour does not have $env");
	return "";
}

sub process_syllabus_units($$$)
{
	my ($syllabus_in, $unit_struct, $codcour)	= (@_);
	my ($unit_count, $total_hours) 			= (0, 0);
	my %accu_hours     				= ();
	
	#                        \begin{unit}{\AL}{}   {Guttag13,Thompson11,Zelle10}{2}{C1,C5}
	$unit_count = 0;
	while($syllabus_in =~ m/(\\begin{unit}.*?\s*(?:.|\n)*?\\end{unit})/g)
	{	
		my $this_unit = $1;
		$unit_count++;
		#                        \begin{unit}{\AL}{}   {Guttag13,Thompson11,Zelle10}{2}{C1,C5}
		if( not $this_unit =~ m/\\begin{unit}{.*?}{.*?}{.*?}{.*?}\s*(?:.|\n)*?\\end{unit}/g )
		{    Util::print_warning("Codcour=$codcour, Unit $unit_count out of format:\n$this_unit\n");
		}
	}

	$unit_count = 0;
	while($syllabus_in =~ m/\\begin{unit}{.*?}{.*?}{.*?}{(.*?)}{.*?}\s*((?:.|\n)*?)\\end{unit}/g)
	{
		$unit_count++;
		my $nhours 	= $1;
		$total_hours   += $nhours;
		if( not looks_like_number($nhours) )
		{	Util::print_warning("Codcour=$codcour, Unit $unit_count, number of hours is wrong ($nhours)");		}
		$accu_hours{$unit_count}  = $total_hours;
	}

	my $all_units_txt     = "";
	my $unit_captions = "";
	$unit_count       = 0;
	$Common::course_info{$codcour}{allbibitems}             = "";
	$Common::course_info{$codcour}{n_units}			= 0;
	$Common::course_info{$codcour}{units}{unit_caption}	= [];
	$Common::course_info{$codcour}{units}{bib_items}	= [];
	$Common::course_info{$codcour}{units}{hours}		= [];
	$Common::course_info{$codcour}{units}{bloom_level}	= [];
	$Common::course_info{$codcour}{units}{topics}    	= [];
	$Common::course_info{$codcour}{units}{unitgoals}	= [];

	my $sep = "";
	while($syllabus_in =~ m/\\begin{unit}{(.*?)}{(.*?)}{(.*?)}{(.*?)}\s*((?:.|\n)*?)\\end{unit}/g)
	{	
		$unit_count++;
		$Common::course_info{$codcour}{n_units}++;
		my ($unit_caption, $unit_bibitems, $unit_hours, $bloom_level, $unit_body) = ($1, $2, $3, $4, $5);
				
		push(@{$Common::course_info{$codcour}{units}{unit_caption}}, $unit_caption);
		push(@{$Common::course_info{$codcour}{units}{bib_items}}   , $unit_bibitems);
		push(@{$Common::course_info{$codcour}{units}{hours}}       , $unit_hours);
		push(@{$Common::course_info{$codcour}{units}{bloom_level}} , $bloom_level);
		$Common::course_info{$codcour}{allbibitems} .= "$sep$unit_bibitems";

		$unit_captions   .= "\\item $unit_caption\n";
		my %map = ();
		$map{UNIT_TITLE}  	= $unit_caption;
		$map{BLOOM_LEVEL}	= $bloom_level;
		if($unit_caption =~ m/\\(.*)/) 
		{
			$unit_caption = $1;
			if( defined($Common::config{topics_priority}{$unit_caption}) )
			{
				if(not defined($Common::map_hours_unit_by_course{$unit_caption}{$codcour}))
				{	$Common::map_hours_unit_by_course{$unit_caption}{$codcour} = 0;		}
				$Common::map_hours_unit_by_course{$unit_caption}{$codcour} += $unit_hours;

				if(not defined($Common::acc_hours_by_course{$codcour}))
				{	$Common::acc_hours_by_course{$codcour}  = 0;						}
				$Common::acc_hours_by_course{$codcour} += $unit_hours;

				if(not defined($Common::acc_hours_by_course{$unit_caption}))
				{	$Common::acc_hours_by_unit{$unit_caption}  = 0;						}
				$Common::acc_hours_by_unit{$unit_caption} += $unit_hours;
			}
		}

		$sep = ",";
		my ($topics, $unitgoals) = ("", "");
		if($unit_body =~ m/(\\begin{topics}\s*((?:.|\n)*?)\\end{topics})/g)
		{	$topics = $1; }
		elsif($unit_body =~ m/(\\.*?AllTopics)/g)
		{	$topics = $1; }

		if($unit_body =~ m/(\\begin{unitgoals}\s*(?:.|\n)*?\\end{unitgoals})/g)
		{	$unitgoals = $1; }
		elsif($unit_body =~ m/(\\.*?AllObjectives)/g)
		{	$unitgoals = $1; }
		push(@{$Common::course_info{$codcour}{units}{topics}},   $topics);
		push(@{$Common::course_info{$codcour}{units}{unitgoals}}, $unitgoals);

		my $thisunit            = $unit_struct;
		$map{HOURS}		= "$unit_hours $Common::config{dictionary}{hours}";
		$map{UNIT_GOAL}		= $unitgoals;
		$map{UNIT_CONTENT}	= $topics;

		$map{PERCENTAGE} = 0;
		$map{PERCENTAGE} = int(100*$accu_hours{$unit_count}/$total_hours+0.5) if($total_hours  > 0 );

		$sep = "";
		my $bib_citations = "";
		foreach my $bibitem (split(",", $unit_bibitems))
		{
			$bib_citations .= "$sep\\cite{$bibitem}";
			$sep = ", ";
		}
		$map{CITATIONS} = $bib_citations;
		$thisunit = Common::replace_tags($thisunit, "--", "--", %map);
		$all_units_txt .= $thisunit;
	}
	Util::check_point("process_syllabus_units");
	return ($all_units_txt, $unit_captions);
}

sub read_syllabus_info($$)
{
	my ($codcour, $semester)   = (@_);
	my $count       = 0;
	my $fullname 	= Common::get_syllabus_full_path($codcour, $semester);
	my $syllabus_in	= Util::read_file($fullname);
# 	Util::print_message("GenSyllabi::read_syllabus_info $codcour ...");
	$syllabus_in =~ s/\\ExpandOutcome{/\\ShowOutcome{/g;
	$syllabus_in =~ s/\\Competence{/\\ShowCompetence{/g;
	$syllabus_in =~ s/{unitgoals}/{learningoutcomes}/g;
	Util::write_file($fullname, $syllabus_in);
	
# 	my $count_old_macros = 0;
# 	($syllabus_in, $count_old_macros) = Common::replace_old_macros($syllabus_in);
# 	Util::write_file($fullname, $syllabus_in);
# 	Util::print_message("Replaced $count_old_macros old macros in file: \"$fullname\"") if($count_old_macros > 0);

	my %map = ();
	# 1st: Get general information from this syllabus
	$Common::course_info{$codcour}{unitcount}	= 0;
	$Common::course_info{$codcour}{justification}	= get_environment($codcour, $syllabus_in, "justification");
	$Common::course_info{$codcour}{goals}         	= get_environment($codcour, $syllabus_in, "goals");
	
	# 2nd: Process its outcomes and learningoutcomes
	foreach my $env ("outcomes", "competences")
	{
	      $Common::course_info{$codcour}{$env}{txt} 	= get_environment($codcour, $syllabus_in, $env);
	      $Common::course_info{$codcour}{$env}{itemized}= "";
	      $Common::course_info{$codcour}{$env}{array}	= [];
	      $Common::course_info{$codcour}{$env}{count}     	= 0;
	}

	my %macro_for_env = ("outcomes" => "ShowOutcome", "competences"=>"ShowCompetence");
	foreach my $env ("outcomes", "competences")
	{
	      foreach my $one_line ( split("\n", $Common::course_info{$codcour}{$env}{txt}) )
	      {
		      my ($key, $level)     = ("", "");
		      my $reg_exp =  "\\\\".$macro_for_env{$env}."{(.*)}{(.*?)}";
		      if( $one_line =~ m/$reg_exp/g )
		      { 
			      ($key, $level) = ($1, $2);
			      $Common::course_info{$codcour}{$env}{$key} = $2; # Instead of "" we must put the level of this outcome/LO
			      push(@{$Common::course_info{$codcour}{$env}{array}}, $key); # Sequential to list later
			      $Common::course_info{$codcour}{$env}{count}++;
			      my $prefix	        = "";
 			      if(defined($Common::config{$env."_map"}) and defined($Common::config{$env."_map"}{$key}) ) # outcome: a), b), c) ... Competence
			      {	$prefix = $Common::config{$env."_map"}{$key};	}
			      $Common::course_info{$codcour}{$env}{itemized} .= "\\item \\".$macro_for_env{$env}."{$key}{$level}\n";
		      }
	      }
	}
	
	$map{COURSE_CODE} 	= $codcour;
	$map{COURSE_NAME} 	= $Common::course_info{$codcour}{course_name};
	$map{COURSE_TYPE}	= $Common::config{dictionary}{$Common::course_info{$codcour}{course_type}};

	$semester 		= $Common::course_info{$codcour}{semester};
	$map{SEMESTER}    	= $semester;
	$map{SEMESTER}         .= "\$^{$Common::config{dictionary}{ordinal_postfix}{$semester}}\$ ";
	$map{SEMESTER}         .= "$Common::config{dictionary}{Semester}.";
	$map{CREDITS}		= $Common::course_info{$codcour}{cr};
	$map{JUSTIFICATION}	= $Common::course_info{$codcour}{justification};
	$map{GOAL}		= "\\begin{itemize}\n$Common::course_info{$codcour}{goals}\n\\end{itemize}";
	$map{OUTCOMES}		= "\\begin{description}\n$Common::course_info{$codcour}{outcomes}{itemized}\\end{description}";
	$map{COMPETENCES}	= "\\begin{description}\n$Common::course_info{$codcour}{competences}{itemized}\\end{description}";
	$map{EVALUATION} 	= $Common::config{general_evaluation};

	#Util::print_message("map{EVALUATION} =\n$map{EVALUATION}");
	if( not $Common::course_info{$codcour}{specific_evaluation} eq "" )
	{	$map{EVALUATION} = $Common::course_info{$codcour}{specific_evaluation};	}
	#Util::print_message("course $codcour\nmap{EVALUATION}=\n$map{EVALUATION}"); 
	#exit;

	($map{PROFESSOR_NAMES}, $map{PROFESSOR_SHORT_CVS}, $map{PROFESSOR_JUST_GRADE_AND_FULLNAME}) = ("", "", "");
	my $sep    = "";
	if(defined($Common::antialias_info{$codcour}))
	{	$codcour = $Common::antialias_info{$codcour}	}
	my $alias = Common::get_alias($codcour);
	if(defined($Common::config{distribution}{$alias}))
	{
		foreach my $email (sort {$Common::config{faculty}{$b}{fields}{degreelevel} <=> $Common::config{faculty}{$a}{fields}{degreelevel}} keys %{$Common::config{distribution}{$alias}})
		{
			if(defined($Common::config{faculty}{$email}{fields}{name}))
			{	
				$map{PROFESSOR_NAMES} 			.= "$Common::config{faculty}{$email}{fields}{name} ";
				$map{PROFESSOR_SHORT_CVS}		.= "\\noindent $Common::config{faculty}{$email}{fields}{prefix} $Common::config{faculty}{$email}{fields}{name}\n";
				$map{PROFESSOR_SHORT_CVS} 		.= "\\begin{itemize}\n";
				$map{PROFESSOR_SHORT_CVS} 		.= "$Common::config{faculty}{$email}{fields}{shortcv}";
				$map{PROFESSOR_SHORT_CVS} 		.= "\\end{itemize}\n\n";
				#$map{PROFESSOR_JUST_GRADE_AND_FULLNAME} .= "$sep$Common::config{faculty}{$email}{fields}{title} $Common::config{faculty}{$email}{fields}{name}";
			}
			$sep = ", ";
		}
	}
	else
	{
 		#Util::print_message("There is no professor assigned to $codcour ($alias) (Sem #$Common::course_info{$codcour}{semester})");
	}
	$Common::course_info{$codcour}{docentes_names}  	= $map{PROFESSOR_NAMES};
	$Common::course_info{$codcour}{docentes_titles}  	= $map{PROFESSOR_TITLES};
	$Common::course_info{$codcour}{docentes_shortcv} 	= $map{PROFESSOR_SHORT_CVS};
	#if($codcour eq "FG101")
	#{     Util::print_message("Professor for course $codcour\n$map{PROFESSOR_SHORT_CVS}");	      exit;	}

	my $horastxt = "";
	$horastxt 			.= "$Common::course_info{$codcour}{th} HT; " if($Common::course_info{$codcour}{th} > 0);
	$horastxt 			.= "$Common::course_info{$codcour}{ph} HP; " if($Common::course_info{$codcour}{ph} > 0);
	$horastxt 			.= "$Common::course_info{$codcour}{lh} HL; " if($Common::course_info{$codcour}{lh} > 0);
	$map{HOURS}			 = $horastxt;
	($map{THEORY_HOURS}, $map{PRACTICE_HOURS}, $map{LAB_HOURS})	= ("", "", "");

	if($Common::course_info{$codcour}{th} > 0)
	{   $map{THEORY_HOURS} = "$Common::course_info{$codcour}{th} $Common::config{dictionary}{THEORY}";	}

	if($Common::course_info{$codcour}{ph} > 0)
	{   $map{PRACTICE_HOURS} = "$Common::course_info{$codcour}{ph} $Common::config{dictionary}{PRACTICE}";	}

	if($Common::course_info{$codcour}{lh} > 0)
	{   $map{LAB_HOURS} = "$Common::course_info{$codcour}{lh} $Common::config{dictionary}{LABORATORY}";	}

	$map{PREREQUISITES} 			= $Common::course_info{$codcour}{code_name_and_sem_prerequisites};
	if($Common::course_info{$codcour}{n_prereq} == 0)
	{	$map{PREREQUISITES_JUST_CODES}	= $Common::config{dictionary}{None};								}
	else
	{	$map{PREREQUISITES_JUST_CODES}	= $Common::course_info{$codcour}{prerequisites_just_codes};		}

	my $syllabus_template = $Common::config{syllabus_template};
	
	my $unit_struct = "";
	if($syllabus_template =~ m/--BEGINUNIT--\s*\n((?:.|\n)*)--ENDUNIT--/)
	{	$unit_struct = $1;	}
	($map{UNITS}, $map{SHORT_DESCRIPTION}) = process_syllabus_units($syllabus_in, $unit_struct, $codcour);
	$map{SHORT_DESCRIPTION} = "\\begin{inparaenum}\n$map{SHORT_DESCRIPTION}\\end{inparaenum}";

	my ($bibfile_in, $bibfile_out) = ("", "");
	if($syllabus_in =~ m/\\bibfile{(.*?)}/g)
	{	$bibfile_in = $1;	$bibfile_in     =~ s/ //g;	}

	$map{BIBSTYLE}	= $Common::config{bibstyle};
	if( $bibfile_in =~ m/.*\/(.*)/)
	{	$bibfile_out 	= $1;	
		$Common::course_info{$codcour}{short_bibfiles} = $1;
	}
	$map{IN_BIBFILE} 	= $bibfile_in;
	$map{BIBFILE} 		= $bibfile_out;
	$Common::course_info{$codcour}{bibfiles} = $bibfile_in;

	foreach (keys %{$Common::course_info{$codcour}{extra_tags}})
	{	$map{$_} = $Common::course_info{$codcour}{extra_tags}{$_};		}
	# TEXT TO CUT
	return %map;
}

sub genenerate_tex_syllabus_file($$%)
{
	my ($codcour, $output_file, %map)   = (@_);

	my $syllabus_template = $Common::config{syllabus_template};
	my $unit_struct = "";
	if($syllabus_template =~ m/--BEGINUNIT--\s*\n((?:.|\n)*)--ENDUNIT--/)
	{	$unit_struct = $1;	}
	$syllabus_template =~ s/--BEGINUNIT--\s*\n((?:.|\n)*)--ENDUNIT--/--UNITS--/g;

	$syllabus_template =~ s/\\newcommand{\\INST}{}/\\newcommand{\\INST}{$Common::institution}/g;
	$syllabus_template =~ s/\\newcommand{\\AREA}{}/\\newcommand{\\AREA}{$Common::area}/g;

	$syllabus_template = Common::replace_tags($syllabus_template, "--", "--", %map);
        $syllabus_template =~ s/--.*?--//g;
        system("rm $output_file");
	Util::write_file($output_file, $syllabus_template);

# 	Util::print_message("Syllabi $output_file ... generated ok!");
# 	Util::print_message($output_file);      exit;
}

sub read_syllabus_template()
{
	my $template_file = Common::get_template("in-syllabus-template-file");
	if(not -e $template_file)
	{	Util::halt("It seems that you forgot the syllabus template file ... verify \"$template_file\"");		}
	$Common::config{syllabus_template} = Util::read_file($template_file);
	
	if( $Common::config{syllabus_template} =~ m/(\\begin{evaluation}\s*\n(?:.|\n)*?\n\\end{evaluation})/g )
	{
	      my $evaluation = $1;
	      my $evaluation_replaced = Common::replace_special_chars($evaluation);
	      $Common::config{syllabus_template}  =~ s/$evaluation_replaced/--EVALUATION--/;
	      $Common::config{general_evaluation} = $evaluation;
	      Util::print_message("File General Evaluation detected ok!");
	}
	else
	{
	      Util::print_error("It seems you did not write General Evaluation Criteria on your Syllabus template (See file: $template_file) ...");
	}
}

# ok, Here we generate syllabi, prerequisitite files
sub process_syllabi()
{
	Common::read_faculty(); 
	Common::read_distribution();
	Common::read_aditional_info_for_silabos(); # Days, time for each class, etc.

	# It generates all the sillabi
	read_syllabus_template();  # 1st  Read the syllabus template
	gen_course_general_info(); # 2nd Generate files containing Prerequisites, etc
	gen_prerequisites_map();   # 3th Generate dot files 
	
	# 4th: Read evaluation info for this institution
	Common::read_specific_evaluacion_info(); # It loads the field: $Common::course_info{$codcour}{specific_evaluation} for each course with specific evaluation
	
	generate_tex_syllabi_files();
        generate_syllabi_include();
 	gen_batch_to_compile_syllabi();
	
	gen_book("syllabi", "../syllabi/", "");
	if( $Common::config{flags}{DeliveryControl} == 1 )
	{	gen_book("syllabi", "../pdf/", "-delivery-control");	
	}
	Util::check_point("gen_syllabi");
}

# ok
sub generate_tex_syllabi_files()
{ 
	Util::precondition("parse_courses");
	
	# Generate all the syllabi
	my $count_courses 	= 0;
	my $OutputTexDir = Common::get_template("OutputTexDir");
	for(my $semester = $Common::config{SemMin}; $semester <= $Common::config{SemMax}; $semester++)
	{
		#foreach my $codcour (@{$Common::courses_by_semester{$semester}})
                foreach my $codcour (sort {$Common::config{area_priority}{$Common::course_info{$a}{prefix}} <=> $Common::config{area_priority}{$Common::course_info{$b}{prefix}}} 
                                         @{$Common::courses_by_semester{$semester}})
		{
			my %map = read_syllabus_info($codcour, $semester);
			genenerate_tex_syllabus_file($codcour, "$OutputTexDir/$codcour.tex", %map);

			# Copy bib files
			my $syllabus_bib = Common::get_template("InSyllabiContainerDir")."/$map{IN_BIBFILE}.bib";
			#Util::print_message("cp $syllabus_bib $OutputTexDir");
			system("cp $syllabus_bib $OutputTexDir");
		}
	}
	Util::check_point("generate_tex_syllabi_files");
}

# ok 
sub gen_batch_to_compile_syllabi()
{
	Util::precondition("set_global_variables");
# 	Util::print_message("gen_batch_to_compile_syllabi starting ...");
	my $out_gen_syllabi = Common::get_template("out-gen-syllabi.sh-file");
	
	my $output = "";
	#$output .= "rm *.ps *.pdf *.log *.dvi *.aux *.bbl *.blg *.toc\n\n";
	$output .= "#!/bin/csh\n";
	$output .= "set course=\$1\n";
	$output .= "if(\$course == \"\") then\n";
	$output .= "set course=\"all\"\n";
	$output .= "endif\n";
# 	$output .= "echo \"codigo=\$course\";\n";
	
	$output .= "\n";
	my $html_out_dir 		 = Common::get_template("OutputHtmlDir");
	my $html_out_dir_syllabi = $html_out_dir."/syllabi";
	$output .= "if(\$course == \"all\") then\n";
	$output .= "rm -rf $html_out_dir_syllabi\n";
	$output .= "endif\n";
	$output .= "mkdir -p $html_out_dir_syllabi\n";

	my $tex_out_dir_syllabi	 = Common::get_template("OutputSyllabiDir");
	$output .= "if(\$course == \"all\") then\n";
	$output .= "rm -rf $tex_out_dir_syllabi\n";
	$output .= "endif\n";
	$output .= "mkdir -p $tex_out_dir_syllabi\n";
	
	my ($gen_syllabi, $cp_bib) = ("", "");
	my $scripts_dir 		= Common::get_template("InScriptsDir");
	my $output_tex_dir 		= Common::get_template("OutputTexDir");
	my $OutputInstDir 		= Common::get_template("OutputInstDir");
	
	my $syllabus_container_dir 	= Common::get_template("InSyllabiContainerDir");
	my $count_courses 		= 0;
	$Common::config{parallel} 	= 0;
	my ($parallel_sep)   = ("");
        $parallel_sep = "&" if($Common::config{parallel} == 1);

	for(my $semester = $Common::config{SemMin}; $semester <= $Common::config{SemMax}; $semester++)
	{
		#foreach my $codcour (@{$Common::courses_by_semester{$semester}})
		$gen_syllabi .= "#Semester #$semester\n";
		foreach my $codcour (sort {$Common::config{area_priority}{$Common::course_info{$a}{prefix}} <=> $Common::config{area_priority}{$Common::course_info{$b}{prefix}}}  @{$Common::courses_by_semester{$semester}})
		{
			$gen_syllabi .= "if(\$course == \"$codcour\" || \$course == \"all\") then\n";
# 			Util::print_message("codcour = $codcour, bibfiles=$Common::course_info{$codcour}{bibfiles}");
			foreach (split(",", $Common::course_info{$codcour}{bibfiles}))
			{
				if($Common::config{parallel} == 1)
                                {
				      $cp_bib .= "if(\$course == \"$codcour\" || \$course == \"*\") then\n";
				      $cp_bib .= "cp $syllabus_container_dir/$_.bib $output_tex_dir$parallel_sep\n";
				      $cp_bib .= "endif\n\n";
                                    $gen_syllabi .= "#cp $syllabus_container_dir/$_.bib $output_tex_dir\n";
                                }
                                else
                                {
                                    $gen_syllabi .= "cp $syllabus_container_dir/$_.bib $output_tex_dir\n";
                                }
 				#Util::print_message("$syllabus_container_dir/$_");
			}
			$gen_syllabi .= "$scripts_dir/gen-syllabus.sh $codcour $OutputInstDir$parallel_sep\n";
			if( $Common::config{flags}{DeliveryControl} == 1 )
			{	$gen_syllabi .= "$scripts_dir/compile-latex.sh $codcour-delivery-control $OutputInstDir$parallel_sep\n";	}
			else
			{	$gen_syllabi .= "#I did not find delivery control file ... (".Common::get_template($Common::template_files{DeliveryControl}).")\n";	}
			$gen_syllabi .= "endif\n";
			$gen_syllabi .= "\n";
			$count_courses++;
		}
	}
	$output .= "\n$cp_bib\n$gen_syllabi";
	Util::write_file($out_gen_syllabi, $output);
	system("chmod 744 $out_gen_syllabi");
	Util::print_message("gen_batch_to_compile_syllabi $Common::institution ($count_courses courses) OK!");
}

sub get_hidden_chapter_info($)
{
	my ($semester) = (@_);
	my $output_tex .= "\% $semester$Common::config{dictionary}{ordinal_postfix}{$semester} $Common::config{dictionary}{Semester}\n";
	$output_tex .= "\\addtocounter{chapter}{1}\n";
	$output_tex .= "\\addcontentsline{toc}{chapter}{$Common::config{dictionary}{semester_ordinal}{$semester} $Common::config{dictionary}{Semester}}\n";
	$output_tex .= "\\setcounter{section}{0}\n";
	return $output_tex;
}

# ok
# GenSyllabi::gen_book("../syllabi", "syllabi/", "");
# GenSyllabi::gen_book("../syllabi", "../pdf/", "-delivery-control");
sub gen_book($$$)
{
	my ($InBook, $prefix, $postfix) = (@_);
	Util::precondition("set_global_variables");
	
	my $InBookFile = "Book-of-$InBook";
	my $OutFileTpl = "out-pdf-$InBook$postfix-includelist-file";
	Util::print_message("Generating $OutFileTpl file ...");
	my $output_tex = "";
	#$output_tex .="rm *.ps *.pdf *.log *.dvi *.aux *.bbl *.blg *.toc\n\n";
	my $count = 0;
	for(my $semester = $Common::config{SemMin}; $semester <= $Common::config{SemMax} ; $semester++)
	{
		$output_tex .= get_hidden_chapter_info($semester);
		#foreach my $codcour (@{$Common::courses_by_semester{$semester}})
                foreach my $codcour (sort {$Common::config{area_priority}{$Common::course_info{$a}{prefix}} <=> $Common::config{area_priority}{$Common::course_info{$b}{prefix}}}  @{$Common::courses_by_semester{$semester}})
		{
			$output_tex .= "\\includepdf[pages=-,addtotoc={1,section,1,$codcour. $Common::course_info{$codcour}{course_name},$codcour}]";
			$output_tex .= "{$prefix$codcour$postfix}\n";
			$count++;
		}
		$output_tex .= "\n";
	}
	my $OutputFile = Common::get_template($OutFileTpl);
	Util::write_file($OutputFile, $output_tex);
 	system("cp ".Common::get_template("in-$InBookFile$postfix-file")." ".Common::get_template("OutputTexDir"));
	system("cp ".Common::get_template("in-$InBookFile$postfix-face-file")." ".Common::get_template("OutputTexDir"));
	Util::print_message("gen_book ($count courses) in $OutputFile OK!");
}

# ok
sub gen_short_descriptions()
{
	Util::precondition("set_global_variables");
	my $file_name = Common::get_template("out-short-descriptions-file");
	my $output_tex = "";
	my $count = 0;
	for(my $semester = $Common::config{SemMin}; $semester <= $Common::config{SemMax} ; $semester++)
	{
		$output_tex .= get_hidden_chapter_info($semester);
                foreach my $codcour (sort {$Common::config{area_priority}{$Common::course_info{$a}{prefix}} <=> $Common::config{area_priority}{$Common::course_info{$b}{prefix}}}  @{$Common::courses_by_semester{$semester}})
		{
			#Util::print_message("codcour = $codcour    ");
			my $sec_title = "$codcour. $Common::course_info{$codcour}{course_name}";
# 			$sec_title 	.= "($semester$Common::config{dictionary}{ordinal_postfix}{$semester} ";
# 			$sec_title 	.= "$Common::config{dictionary}{Semester})";
			$output_tex .= "\\section{$sec_title}\\label{sec:$codcour}\n";
			$output_tex .= "$Common::course_info{$codcour}{justification}\n\n";
			$count++;
		}
		$output_tex .= "\n";
	}
	Util::write_file($file_name, $output_tex);
	system("cp ".Common::get_template("in-Book-of-descriptions-main-file")." ".Common::get_template("OutputTexDir"));
	my $command = "cp ".Common::get_template("in-Book-of-descriptions-face-file")." ".Common::get_template("OutputTexDir");
# 	Util::print_warning($command);
	system($command);
	Util::print_message("gen_short_descriptions $file_name ($count courses) OK!");
}

# ok
sub gen_list_of_units_by_course()
{
	Util::precondition("set_global_variables");
	my $file_name = Common::get_template("out-list-of-unit-by-course-file");
	my $output_tex = "";
	my $count = 0;
	for(my $semester = $Common::config{SemMin}; $semester <= $Common::config{SemMax} ; $semester++)
	{
		$output_tex .= get_hidden_chapter_info($semester);
		#foreach my $codcour (@{$Common::courses_by_semester{$semester}})
                foreach my $codcour (sort {$Common::config{area_priority}{$Common::course_info{$a}{prefix}} <=> $Common::config{area_priority}{$Common::course_info{$b}{prefix}}}  @{$Common::courses_by_semester{$semester}})
		{
			my $codcour_label 	= Common::get_label($codcour);
			my $i = 0;
			my $sec_title = "$codcour_label. $Common::course_info{$codcour}{course_name}";
 			#$sec_title 	.= "($semester$Common::config{dictionary}{ordinal_postfix}{$semester} ";
 			#$sec_title 	.= "$Common::config{dictionary}{Semester})";
			$output_tex .= "\\section{$sec_title}\\label{sec:$codcour}\n";
			#for($i = 0 ; $i < $Common::course_info{$codcour}{outcomes}{count}; $i++)
			$output_tex .= "\\subsection{Resultados}\n";
			$output_tex .= "\\begin{itemize}\n";
			my $outcomes_txt = "";
			foreach my $outcome_key (@{$Common::course_info{$codcour}{outcomes}{array}}) # Sequential to list later
			{
				my $bloom 	= $Common::course_info{$codcour}{outcomes}{$outcome_key};
				$outcomes_txt  .= "\\item \\ref{out:Outcome$outcome_key}) \\Outcome$outcome_key"."Short [$bloom, ~~~~~]\n";
			}
			if( $Common::course_info{$codcour}{outcomes}{count} == 0 )
			{	$output_tex .= "\t\\item $Common::config{dictionary}{None}\n";	}
			$output_tex .= $outcomes_txt;
			$output_tex .= "\\end{itemize}\n\n";

			$output_tex .= "\\subsection{Unidades}\n";
			$output_tex .= "\\begin{itemize}\n";
			my $units_txt = "";
			for($i = 0 ; $i < $Common::course_info{$codcour}{n_units}; $i++)
			{
			      $units_txt .= "\t\\item $Common::course_info{$codcour}{units}{unit_caption}[$i], ";
			      $units_txt .= "$Common::course_info{$codcour}{units}{hours}[$i] $Common::config{dictionary}{hrs}, ";
			      $units_txt .= "[$Common::course_info{$codcour}{units}{bloom_level}[$i], ~~~~~]\n";
			}
			#if( $Common::course_info{$codcour}{n_units} == 0 )
			if( $i == 0 )
			{	$units_txt = "\t\\item $Common::config{dictionary}{None}\n";	}
			$output_tex .= $units_txt;
			$output_tex .= "\\end{itemize}\n\n";
			$count++;
		}
		$output_tex .= "\n";
	}
	Util::write_file($file_name, $output_tex);
	system("cp ".Common::get_template("in-Book-of-units-by-course-main-file")." ".Common::get_template("OutputTexDir"));
	system("cp ".Common::get_template("in-Book-of-units-by-course-face-file")." ".Common::get_template("OutputTexDir"));
	Util::print_message("gen_list_of_units_by_course $file_name ($count courses) OK!");
}

# pending
sub gen_bibliography_list()
{
	Util::precondition("set_global_variables");
	my $file_name = Common::get_template("out-bibliography-list-file");
	my $count = 0;
	my $output_tex = "";

	for(my $semester = $Common::config{SemMin}; $semester <= $Common::config{SemMax} ; $semester++)
	{
		$output_tex .= get_hidden_chapter_info($semester);
		#foreach my $codcour (@{$Common::courses_by_semester{$semester}})
                foreach my $codcour (sort {$Common::config{area_priority}{$Common::course_info{$a}{prefix}} <=> $Common::config{area_priority}{$Common::course_info{$b}{prefix}}}  @{$Common::courses_by_semester{$semester}})
		{
			# print "codcour=$codcour ...\n";
			my $bibfiles = $Common::course_info{$codcour}{short_bibfiles};
			#print "codcour = $codcour    ";
			my $sec_title = "$codcour. $Common::course_info{$codcour}{course_name} ";
# 			$sec_title .= "($semester$Common::rom_postfix{$semester} sem)";
			$output_tex .= "\\section{$sec_title}\\label{sec:$codcour}\n";
			$output_tex .= "\\begin{btUnit}%\n";
			$output_tex .= "\\nocite{$Common::course_info{$codcour}{allbibitems}}\n";
			$output_tex .= "\\begin{btSect}[apalike]{$bibfiles}%\n";
			$output_tex .= "\\btPrintCited\n";
			$output_tex .= "\\end{btSect}%\n";	
			$output_tex .= "\\end{btUnit}%\n\n";
			#$output_tex .= "$Common::course_info{$codcour}{justification}\n\n";
			$count++;
		}
		$output_tex .= "\n";
	}
	Util::write_file($file_name, $output_tex);
	system("cp ".Common::get_template("in-Book-of-bibliography-file")." ".Common::get_template("OutputTexDir"));
	system("cp ".Common::get_template("in-Book-of-bibliography-face-file")." ".Common::get_template("OutputTexDir"));
	Util::print_message("gen_bibliography_list $file_name ($count courses) OK!");
}

sub generate_syllabi_include()
{
        my $output_file = Common::get_template("out-list-of-syllabi-include-file");
        my $output_tex  = "";

        $output_tex  .= "%This file is generated automatically ... do not touch !!! (GenSyllabi.pm)\n";
        $output_tex  .= "\\newcounter{conti}\n";

        my $ncourses    = 0;
	my $newpage = "";
        for(my $semester = $Common::config{SemMin}; $semester <= $Common::config{SemMax} ; $semester++)
        {
                $output_tex .= "\n";
                $output_tex .= "\\addcontentsline{toc}{section}{$Common::config{dictionary}{semester_ordinal}{$semester} ";
                $output_tex .= "$Common::config{dictionary}{Semester}}\n";
                foreach my $codcour (sort {$Common::config{area_priority}{$Common::course_info{$a}{prefix}} <=> $Common::config{area_priority}{$Common::course_info{$b}{prefix}}}  
			    @{$Common::courses_by_semester{$semester}})
                {
			my $course_path = Common::get_syllabus_full_path($codcour, $semester);
			$course_path =~ s/(.*)\.tex/$1/g;
			$output_tex .= "$newpage\\input{$course_path}";
                        $output_tex .= "% $Common::course_info{$codcour}{course_name}\n";
                        $ncourses++;
			$newpage = "\\newpage";
                }
                $output_tex .= "\n";
        }
        Util::write_file($output_file, $output_tex);
        Util::print_message("generate_syllabi_include() OK!");
}

sub gen_course_general_info()
{
	my $OutputPrereqDir = Common::get_template("OutputPrereqDir");
	my $OutputFigDir = Common::get_template("OutputFigDir");
	for(my $semester = $Common::config{SemMin}; $semester <= $Common::config{SemMax} ; $semester++)
	{
		#foreach my $codcour (@{$Common::courses_by_semester{$semester}})
                foreach my $codcour (sort {$Common::config{area_priority}{$Common::course_info{$a}{prefix}} <=> $Common::config{area_priority}{$Common::course_info{$b}{prefix}}}  @{$Common::courses_by_semester{$semester}})
		{
			my $normal_header   = "\\begin{itemize}\n";

			# Semester: 5th Sem.
			$normal_header .= "\\item {\\bf $Common::config{dictionary}{Semester}}: ";
			$normal_header .= "$semester\$^{$Common::config{dictionary}{ordinal_postfix}{$semester}}\$ ";
			$normal_header .= "$Common::config{dictionary}{Sem}. ";

			# Credits
			$normal_header .= "{\\bf $Common::config{dictionary}{Credits}}: $Common::course_info{$codcour}{cr}\n";

			# Hours of this course
			$normal_header .= "\\item {\\bf $Common::config{dictionary}{HoursOfThisCourse}}: ";
			if($Common::course_info{$codcour}{th} > 0)
			{	$normal_header .= "{\\bf $Common::config{dictionary}{Theory}}: $Common::course_info{$codcour}{th} $Common::config{dictionary}{hours}; ";	}
			if($Common::course_info{$codcour}{ph} > 0)
			{	$normal_header .= "{\\bf $Common::config{dictionary}{Practice}}: $Common::course_info{$codcour}{ph} $Common::config{dictionary}{hours}; ";	}
			if($Common::course_info{$codcour}{lh} > 0)
			{	$normal_header .= "{\\bf $Common::config{dictionary}{Laboratory}}: $Common::course_info{$codcour}{lh} $Common::config{dictionary}{hours}; ";	}
			$normal_header .= "\n";

			my $syllabus_link = "";
			$syllabus_link .= "\t\\begin{htmlonly}\n";
			$syllabus_link .= "\t\\item {\\bf $Common::config{dictionary}{Syllabus}}:\n";
			$syllabus_link .= "\t\t\\begin{rawhtml}\n";
			$syllabus_link .=  "\t\t\t<a href=\"syllabi/$codcour.pdf\">$Common::config{dictionary}{Syllabus} (PDF)</a>\n";
			$syllabus_link .=  "\t\t\t".Common::get_pdf_icon_link($codcour)."\n";
			$syllabus_link .=  "\t\t\\end{rawhtml}\n";
			$syllabus_link .=  "\t\\end{htmlonly}\n";
			$normal_header .= $syllabus_link;
			
			my $prereq_txt = "\\item {\\bf $Common::config{dictionary}{Prerequisites}}: ";
			if($Common::course_info{$codcour}{n_prereq} == 0)
			{	$prereq_txt .= "$Common::config{dictionary}{None}\n";	}
			else
			{
				$prereq_txt .= "\n\t\\begin{itemize}\n";
				foreach my $course (@{$Common::course_info{$codcour}{full_prerequisites}})
				{
					$prereq_txt .= "\t\t\\item $course\n";
				}
				$prereq_txt .= "\t\\end{itemize}\n";
			}
			$normal_header .= $prereq_txt;
			$normal_header    .= "\\end{itemize}\n";
			
			my $output_file = "$OutputPrereqDir/$codcour";
			Util::write_file("$output_file.tex", $normal_header);

			my $output_tex  = "";
			$output_tex    .= "\\input{$output_file}\n\n";
			$output_tex    .= "\\begin{figure}\n";
			$output_tex    .= "\\centering\n";
			$output_tex    .= "\\includegraphics[scale=0.66]{\\OutputFigDir/$codcour}\n";
			$output_tex    .= "\\caption{Cursos relacionados con \\htmlref{$codcour}{sec:$codcour}}\n";
			$output_tex    .= "\\label{fig:prereq:$codcour}\n";
			$output_tex    .= "\\end{figure}\n";

			Util::write_file("$output_file-html.tex", $output_tex);
		}
	 }
}

sub gen_prerequisites_map()
{
	my $size = "big";
	my $course_tpl 	= Util::read_file(Common::get_template("in-$size-graph-item.dot"));

	my $OutputDotDir  		= Common::get_template("OutputDotDir");
	my $OutputFigDir 		= Common::get_template("OutputFigDir");
	my $update_page_numbers_file 	= Common::get_template("update-page-numbers");

	my $batch_replace_pages = "";
	my $batch_txt 		= "#!/bin/csh\n\n";
	
	for(my $semester = $Common::config{SemMin}; $semester <= $Common::config{SemMax} ; $semester++)
	{
		$batch_txt .= "# Semester #$semester\n";
		foreach my $codcour (@{$Common::courses_by_semester{$semester}})
		{
			my $min_sem_to_show 	= $Common::course_info{$codcour}{semester};
			my $max_sem_to_show 	= $Common::course_info{$codcour}{semester};
			my %courses_by_semester = ();
			push(@{$courses_by_semester{$Common::course_info{$codcour}{semester}}}, $codcour);
			
			my $output_file = "$OutputDotDir/$codcour.dot";
			my $prev_courses_dot = "";
			
			foreach my $codprev (@{$Common::course_info{$codcour}{prerequisites_for_this_course}})
			{	$prev_courses_dot .= Common::generate_course_info_in_dot($codprev, $course_tpl)."\n";	
				$prev_courses_dot .= "\t\"$codprev\"->\"$codcour\" [lhead=cluster$codcour];\n";
				if($Common::course_info{$codprev}{semester} < $min_sem_to_show)
				{	$min_sem_to_show = $Common::course_info{$codprev}{semester};	}
				push(@{$courses_by_semester{$Common::course_info{$codprev}{semester}}}, $codprev);
			}
			
 			my $this_course_dot = Common::generate_course_info_in_dot($codcour, $course_tpl)."\n";
 			
			my $post_course_dot = "";
			foreach my $codpost (@{$Common::course_info{$codcour}{courses_after_this_course}})
			{	$post_course_dot  .= Common::generate_course_info_in_dot($codpost, $course_tpl)."\n";	
				$post_course_dot .= "\t\"$codcour\"->\"$codpost\" [ltail=cluster$codcour];\n";
				if($Common::course_info{$codpost}{semester} > $max_sem_to_show)
				{	$max_sem_to_show = $Common::course_info{$codpost}{semester};	}
				push(@{$courses_by_semester{$Common::course_info{$codpost}{semester}}}, $codpost);
			}
			
			my $sem_col 		= "";
			my $sem_definitions 	= "";
			my $same_rank 		= "";
			my $sep 		= "";
			for( my $sem_count = $min_sem_to_show; $sem_count <= $max_sem_to_show; $sem_count++)
			{	
				my $sem_label = Common::sem_label($sem_count);
				my $this_sem = "\t{ rank = same; $sem_label; "; 
				foreach my $one_cour (@{$courses_by_semester{$sem_count}})
				{	$this_sem .= "\"$one_cour\"; ";		}
				$same_rank .= "$this_sem }\n";
				$sem_col .= "$sep$sem_label";
# 				,fillcolor=black,style=filled,fontcolor=white
				$sem_definitions .= "\t$sem_label [shape=box];\n";
				$sep = "->";
			}
			my $output_tex  = "";
			# Semester: Ej. 5th Sem.
			$output_tex .= "digraph $codcour\n";
			$output_tex .= "{\n";
			$output_tex .= "\tbgcolor=white;\n";
			$output_tex .= "\tcompound=true;\n";
			$output_tex .= "\t$sem_col;\n\n";
			$output_tex .= $sem_definitions;
			if(not $prev_courses_dot eq "")
			{	$output_tex .= "$prev_courses_dot\n";	}
			
			$output_tex .= "\tsubgraph cluster$codcour\n";
			$output_tex .= "\t{\n";
			$output_tex .= "\t\tbgcolor=yellow;\n";
			$output_tex .= "\t\tcolor=yellow;\n";
			$output_tex .= "\t$this_course_dot\n";
			$output_tex .= "\t}\n";
			
			if(not $post_course_dot eq "")
			{	$output_tex .= "$post_course_dot\n";	}
			$output_tex .= "$same_rank\n";
			
			$output_tex .= "}\n";
			
			Util::write_file($output_file, $output_tex);
			$batch_txt	.= "dot -Gcharset=$Common::config{encoding} -Tps $output_file -o $OutputFigDir/$codcour.ps; \n";
			$batch_txt	.= "convert $OutputFigDir/$codcour.ps $OutputFigDir/$codcour.png&\n\n";
			#exit;
		}
	 }
	 my $batch_map_for_course_file = Common::get_template("out-gen-map-for-course");
	 Util::write_file($batch_map_for_course_file, $batch_txt);
	 system("chmod 744 $batch_map_for_course_file");
}

1;