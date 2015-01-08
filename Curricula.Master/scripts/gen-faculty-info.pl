#!/usr/bin/perl -w
use strict;
use scripts::Lib::Common;
use scripts::Lib::GenSyllabi;

if( defined($ENV{'CurriculaParam'}))	{ $Common::command = $ENV{'CurriculaParam'};	}
if(defined($ARGV[0])) { $Common::command = shift or Util::halt("There is no command to process (i.e. AREA-INST)");	}

# flush stdout with every print -- gives better feedback during
# long computations
$| = 1;

sub generate_information_4_professor($)
{
      my ($email) = (@_);
      if( scalar (keys %{$Common::config{faculty}{$email}{fields}{courses_assigned}}) == 0 )
      {	return "";	}
      my $this_professor = $Common::config{faculty_tpl_txt};
      my $more = "";
      my $OutputFacultyFigDir = Common::get_template("OutputFacultyFigDir");
      
      if( -e "$Common::config{InFacultyPhotosDir}/$email.jpg" )
      {		
		system("cp $Common::config{InFacultyPhotosDir}/$email.jpg $OutputFacultyFigDir/.");
		$Common::config{faculty}{$email}{fields}{photo} = "fig/$email.jpg";
      }
      else
      {		system("cp $Common::config{NoFaceFile} $OutputFacultyFigDir/.");
		$Common::config{faculty}{$email}{fields}{photo} = "fig/noface.gif";
      }
      my $email_png = "$OutputFacultyFigDir/$Common::config{faculty}{$email}{fields}{emailwithoutat}.png";
      #http://www.imagemagick.org/script/convert.php
      my $email_length = length($email);
      my $width = int($email_length * 8.6);
      system("convert -size $width"."x16 canvas:none -background white -font Bookman-Demi -pointsize 14 -draw \"text 0,12 '$email'\" $email_png&");

      my $concentration = $Common::config{faculty}{$email}{concentration};
      my $degreelevel	= $Common::config{faculty}{$email}{fields}{degreelevel};

      if(not defined($Common::config{faculty_groups}{$concentration}{$degreelevel}) )
      {		 $Common::config{faculty_groups}{$concentration}{$degreelevel} = [];	      }
      push(@{$Common::config{faculty_groups}{$concentration}{$degreelevel}}, $email);
      
      #my $cict = $Common::config{faculty}{"ecuadros\@ucsp.edu.pe"}{fields}{courses_i_could_teach};
      #Util::print_message("Courses I could teach: $cict"); exit;
      my $codcour = "";
      foreach $codcour ( keys $Common::config{faculty}{$email}{fields}{courses_assigned} )
      {
	    if( not defined($Common::config{faculty}{$email}{fields}{courses_i_could_teach}{$codcour} ) )
	    {	$Common::config{faculty}{$email}{fields}{courses_i_could_teach}{$codcour} = "";
		Util::print_message("> > > > > Professor $email has assigned course $codcour but he is not able to teach that course ... < < < < <");
	    }
      }
      
      foreach $codcour ( sort {$Common::course_info{$a}{semester} <=> $Common::course_info{$b}{semester}} keys %{$Common::config{faculty}{$email}{fields}{courses_i_could_teach}} )
      {
	    my $link = $Common::course_info{$codcour}{link};
	    if( defined($Common::config{faculty}{$email}{fields}{courses_assigned}{$codcour} ) )
	    {	$Common::config{faculty}{$email}{fields}{list_of_courses_assigned}    .= Common::GetCourseHyperLink($codcour, $link);	}
	    else
	    {	$Common::config{faculty}{$email}{fields}{other_courses_he_may_teach}  .= Common::GetCourseHyperLink($codcour, $link);	}
      }
      foreach my $field (keys %{$Common::config{faculty}{$email}{fields}})
      {
		my ($before, $after) = ("", "");
		$before = $Common::config{faculty_icons}{before}{$field} if( defined($Common::config{faculty_icons}{before}{$field}) );
		$after  = $Common::config{faculty_icons}{after}{$field} if( defined($Common::config{faculty_icons}{after}{$field}) );
		my $field_formatted = "$before";
		$field_formatted .= "$Common::config{faculty}{$email}{fields}{$field}";
		$field_formatted .= "$after";
		if( $this_professor =~ m/--$field--/g )
		{
		    $this_professor =~ s/--$field--/$field_formatted/g;
		}
		else
		{
		    $this_professor =~ s/--$field--//g;
		}
      }     
      $this_professor =~ s/--.*?--//g;
      return $this_professor;
}

sub generate_faculty_info()
{
	Util::precondition("read_distribution");
 	%{$Common::config{faculty_icons}{before}} = ("shortcvhtml" => "<ul>\n",
						     "email" => "<img style=\"width: 16px; height: 16px;\" title=\"email\" alt=\"email\" src=\"icon/email.png\">",
						     "emailwithoutat" => "<img style=\"width: 16px; height: 16px;\" title=\"email\" alt=\"email\" src=\"icon/email.png\">\n\t<img style=\"height: 16px;\" title=\"email\" alt=\"email\" src=\"fig/",
						     "phone" => " <img style=\"width: 16px; height: 16px;\" title=\"phone\" alt=\"phone\" src=\"icon/phone.png\">",
						     "mobile" => " <img style=\"width: 16px; height: 16px;\" title=\"mobile\" alt=\"mobile\" src=\"icon/mobile.png\">",
					             "office" => " <img style=\"width: 16px; height: 16px;\" title=\"office\" alt=\"office\" src=\"icon/office.png\"> ",
						     "webpage" => "  <a title=\"Webpage\" href=\"",
					             "facebook" => " <a title=\"Facebook\" href=\"",
						     "twitter" => " <a title=\"Twitter\" href=\"https://www.twitter.com/",
						     "blog" => " <a title=\"Blog\" href=\"",
					             "research" => " <img style=\"width: 16px; height: 16px;\" title=\"email\" alt=\"email\" src=\"icon/research.png\">",
					             "courses" => " <img style=\"width: 16px; height: 16px;\" title=\"email\" alt=\"email\" src=\"icon/courses.png\">",
					             "list_of_courses_assigned" => "<b>Courses assigned:</b>\n<ul>\n",
					             "other_courses_he_may_teach" => "<b>Other courses he/she can teach:</b>\n<ul>\n"
	);
	%{$Common::config{faculty_icons}{after}}  = ("shortcvhtml" => "\t</ul>",
						     "email" => "",
						     "emailwithoutat" => ".png\">",
						     "phone" => "<br>",
						     "mobile" => "",
						     "office" => "<br>",
					             "webpage"  => "\"> <img style=\"width: 16px; height: 16px;\" title=\"webpage\" alt=\"webpage\" src=\"icon/webpage.png\">Webpage</a> ",
					             "facebook" => "\"> <img style=\"width: 16px; height: 16px;\" title=\"facebook\" alt=\"facebook\" src=\"icon/facebook.png\"></a> ",
						     "twitter" => "\"> <img style=\"width: 16px; height: 16px;\" title=\"twitter\" alt=\"twitter\" src=\"icon/twitter.png\"></a> ",
						     "blog" => "\"> <img style=\"width: 16px; height: 16px;\" title=\"blog\" alt=\"blog\" src=\"icon/blog.png\"></a> ",
					             "research" => "",
					             "courses" => "",
					             "list_of_courses_assigned" => "</ul>\n",
					             "other_courses_he_may_teach" => "</ul>\n"
	);

	my $faculty_tpl_file 		= Common::get_template("faculty-template.html");
	
	$Common::config{faculty_tpl_txt}= Util::read_file($faculty_tpl_file);
	
	$Common::config{InFacultyPhotosDir} 		= Common::get_template("InFacultyPhotosDir");
	$Common::config{InFacultyIconsDir}		= Common::get_template("InFacultyIconsDir");
	$Common::config{NoFaceFile}			= Common::get_template("NoFace-file");
	$Common::config{OutputFacultyDir} 		= Common::get_template("OutputFacultyDir");
	
	#my $faculty_output_general_txt 	= "<table style=\"width: 600px;\" border=\"0\" align=\"center\">\n";
	my $faculty_output_general_txt 	= "\n";
	my $faculty_general_output 	= Common::get_template("faculty-general-output-html");
	my $email = "";
	Util::print_message("Generating faculty file: $faculty_general_output  ...");
	
	# 1st verify if all professors have concentration ...
	my $count_of_errors = 0;
	foreach $email (keys %{$Common::config{faculty}})
	{
	      my $concentration = $Common::config{faculty}{$email}{concentration};
	      if($concentration eq "" or not defined($Common::config{sort_areas}{$concentration}) )
	      {		Util::print_message("Professor $email:  I do not recognize this concentration area (\"$concentration\") ...");
			$count_of_errors++;
	      }
	}

	if($count_of_errors > 0)
	{	Util::print_error("Some professors ($count_of_errors in total) have not concentration area or have invalid ones ...");		}

	# 2nd sort them by areas, degreelevel, name
	my @faculty_sorted_by_priority = sort {  ($Common::config{sort_areas}{$Common::config{faculty}{$a}{concentration}} <=> $Common::config{sort_areas}{$Common::config{faculty}{$b}{concentration}}) ||
			     ($Common::config{faculty}{$b}{fields}{degreelevel} <=> $Common::config{faculty}{$a}{fields}{degreelevel}) ||
			     ($Common::config{faculty}{$a}{fields}{name} cmp $Common::config{faculty}{$b}{fields}{name})
			  } keys %{$Common::config{faculty}};
	my $concentration 		= "";
	my $degreelevel;

	# 3rd Generate information for each professor
	my $OutputFacultyIconDir = Common::get_template("OutputFacultyIconDir");
	system("cp $Common::config{InFacultyIconsDir}/*.png $OutputFacultyIconDir");
	foreach $email ( @faculty_sorted_by_priority )
	{
	    my $this_professor = generate_information_4_professor($email);
	    if( scalar (keys %{$Common::config{faculty}{$email}{fields}{courses_assigned}}) > 0 )
	    {	      $faculty_output_general_txt .= $this_professor;		}
	}
	
	# 4th Generate information for the main index of professors by area, etc
# 	push(@{$Common::config{faculty_groups}{$concentration}{$degreelevel}}, $email);

# my @faculty_sorted_by_priority = sort {  ($Common::config{sort_areas}{$Common::config{faculty}{$a}{concentration}} <=> $Common::config{sort_areas}{$Common::config{faculty}{$b}{concentration}}) ||
# 			     ($Common::config{faculty}{$b}{fields}{degreelevel} <=> $Common::config{faculty}{$a}{fields}{degreelevel}) ||
# 			     ($Common::config{faculty}{$a}{fields}{name} cmp $Common::config{faculty}{$b}{fields}{name})
# 			  } keys %{$Common::config{faculty}};
			  
	my $index_of_professors = "<table border=\"1\" align=\"center\">\n";
	foreach $concentration (sort {$Common::config{sort_areas}{$a} <=> $Common::config{sort_areas}{$b}} keys %{$Common::config{faculty_groups}})
 	{	$index_of_professors .= "<th>$concentration</th>\n";		}
	

	$index_of_professors .= "<tr>\n";
 	foreach $concentration (sort {$Common::config{sort_areas}{$a} <=> $Common::config{sort_areas}{$b}} keys %{$Common::config{faculty_groups}})
 	{
	      $index_of_professors .= "<td>\n";
	      foreach $degreelevel ( sort {$b <=> $a} keys %{$Common::config{faculty_groups}{$concentration}} )
	      {
		    my $count = 0;
		    my $this_group_txt = "";
		    foreach $email ( @{$Common::config{faculty_groups}{$concentration}{$degreelevel}} )
		    {
			  if( scalar (keys %{$Common::config{faculty}{$email}{fields}{courses_assigned}}) > 0 )
			  {
				$this_group_txt .= "<li>";
				$this_group_txt .= "<a href=\"#$Common::config{faculty}{$email}{fields}{emailwithoutat}\">";
				$this_group_txt .= "$Common::config{faculty}{$email}{fields}{prefix} $Common::config{faculty}{$email}{fields}{name}";
				$this_group_txt .= "</a>";
				$this_group_txt .= "</li>\n";
				$count++;
			  }
		    }
		    if( $count > 0 ) 
		    {
			$index_of_professors .= "<ul>\n";
			$index_of_professors .= $this_group_txt;
			$index_of_professors .= "</ul>\n";
		    }
	      }
	      #$Common::config{faculty}{$email}{fields}{anchor}
	      
	      $index_of_professors .= "</td>\n";
 	}
 	$index_of_professors .= "</tr>\n";
 	$index_of_professors .= "</table>\n";
	
	
	
	Util::print_message("Generating file: $faculty_general_output ...");
	#$faculty_output_general_txt 	.= "</table>\n";
	$faculty_output_general_txt 	.= "\n";
	my $html_output  = "<h2 id=\"top\"></h2>";
	   $html_output .= "$index_of_professors\n";
	   $html_output .= "$faculty_output_general_txt";
	
	Util::write_file($faculty_general_output, $html_output);
	Util::check_point("generate_faculty_info");
	Util::print_message("generate_faculty_info OK! ...");
}

sub generate_link_for_courses()
{
      my $html_index 	= Common::get_template("output-curricula-html-file");
      if( not -e $html_index )
      {		Util::print_error("File $html_index does not exist ! ... Run latex2html first ... ");
      }
      Util::print_message("Reading $html_index");
      my $html_file 	= Util::read_file($html_index);
      
      for(my $semester= 1; $semester <= $Common::config{n_semesters} ; $semester++)
      {
	    foreach my $codcour (sort {$Common::config{area_priority}{$Common::course_info{$a}{prefix}} <=> $Common::config{area_priority}{$Common::course_info{$b}{prefix}}}  @{$Common::courses_by_semester{$semester}})
	    {
		  if(defined($Common::antialias_info{$codcour}))
		  {	$codcour = $Common::antialias_info{$codcour}	}
		  my $alias = Common::get_alias($codcour);
		  my $link = "";
# 		                <A NAME="tex2html315" HREF="4_1_CS105_Estructuras_Discr.html"><SPAN CLASS="arabic">4</SPAN>.<SPAN CLASS="arabic">1</SPAN> CS105. Estructuras Discretas I (Obligatorio)</A>
		  
		  if( $html_file =~ m/<A(?:.|\n)*?HREF="(.*?)".*?$codcour\. $Common::course_info{$codcour}{course_name} \($Common::config{dictionary}{$Common::course_info{$codcour}{course_type}}\).*?<\/A>/)
		  {
			$link = $1;
			$Common::course_info{$codcour}{link} = $link;
			#Util::print_message("$codcour. $Common::course_info{$codcour}{course_name} ($Common::config{dictionary}{$Common::course_info{$codcour}{course_type}})=>$link");
# 			Util::print_message("codcour=$codcour ($Common::config{dictionary}{$Common::course_info{$codcour}{course_type}}), link = $link");
		  }
		  else
		  {	Util::print_error("I did not find a link for course $codcour ... (see $html_index file ...)");	  
		  }
	    }
      }
}

sub main()
{
# 	Util::begin_time();
	Common::setup(); 
	
	Common::read_faculty(); 
	Common::read_distribution();
	Common::read_aditional_info_for_silabos(); # Days, time for each class, etc.
	
	generate_link_for_courses();
	generate_faculty_info();
	
# 	my $maintxt		= Util::read_file(Common::get_template("curricula-main"));
	
# 	my $output_file = Common::get_template("unified-main-file");
#  	Util::write_file($output_file, $maintxt);
}

main();

