package Util;
use strict;
use POSIX;
use POSIX qw(setsid);
use POSIX qw(:errno_h :fcntl_h);
use Carp::Assert;

our %control	= ();
# ok
sub precondition($)
{
	my ($key) = (@_);
	assert(defined($control{$key}));
	assert($control{$key} == 1);
}

# ok
sub check_point($)
{
	my ($key) = (@_);
	$control{$key} = 1;
}

# ok
sub uncheck_point($)
{
	my ($key) = (@_);
	$control{$key} = 0;
}

sub is_checked_point($)
{
        my ($key) = (@_);
        if(defined($control{$key}) and $control{$key} == 1)
        {    return 1;          }
        return 0;
}

# ok
sub print_message($)
{
	my ($msg) = (@_);
	print "$msg\n";
}

# ok
sub print_error($)
{
	my ($msg) = (@_);
	print "** ERROR ** : ";
	print "$msg\n";
	assert(0);
	exit;
}

# ok
sub print_warning($)
{
	my ($msg) = (@_);
	print "** WARNING ** : ";
	print "$msg\n";
}

#  ok
sub halt($)
{
	my ($msg) = (@_);
	print_error($msg);
	assert(0);
	exit;
}

sub get_ang_base($)
{
	my ($nareas) = (@_);
	return (2*3.14)/$nareas;
}

sub rotate($$$)
{
	my ($x, $y, $ang)  = (@_);
	my ($xp,$yp) = ($x*cos($ang)-$y*sin($ang), $x*sin($ang)+$y*cos($ang));
	return ($xp,$yp);
}

sub round($)
{
	my ($f) = (@_);
	my $txt = "$f";
	if( $txt =~ m/(.*?\...)/)
 	{	return $1;	}
 	return $f;
}

sub calc_percent($$)
{
	my ($part, $total) = (@_);
	my $percent = 100 * $part/$total;
	if($percent =~ m/(.*\..).*/)
	{	$percent  = $1;
	}
	return $percent;
}

# ok
sub read_file($)
{
	my ($filename) = (@_);
	open(IN, "<$filename") or Util::halt("read_file: $filename does not open");
	my @lines = <IN>;
	close(IN);
	return join("", @lines);
}

# ok

sub write_file($$)
{
	my ($filename, $txt) = (@_);
	open(OUT, ">$filename") or die Util::halt("write_file: $filename does not open");
	print OUT $txt;
	close(IN);
}

my @list_of_files_to_gen_fig;
sub write_file_to_gen_fig($$)
{
        # First: write this file
	my ($fullname, $txt) = (@_);
        write_file($fullname, $txt);
        #print_message("write_file_to_gen_fig: $fullname");

        $fullname =~ m/(.*)\/(.*)\.tex/;
        my ($dir, $filename) = ($1, $2);

        # Second: generate the main to gen the fig
        my $main_txt = $Common::config{main_to_gen_fig};
        $main_txt =~ s/<OUTPUT_FILE>/$filename/g;
	write_file("$dir/$filename-main.tex", $main_txt);

        # Third: register this main to compile later
	push(@list_of_files_to_gen_fig, $filename);
}

sub generate_batch_to_gen_figs($)
{
	my ($output_file) = (@_);
        #print_message("generate_batch_to_gen_figs($output_file)");
	my $output_txt  = "";
	foreach my $fig_file (@list_of_files_to_gen_fig)
	{
                $output_txt .= "latex main-to-gen-fig-$fig_file\n";
                #$output_txt .= "dvips -Ppdf -Pcmz -o $fig_file.ps main-to-gen-fig-$fig_file\n";
                $output_txt .= "dvips -o $fig_file.ps main-to-gen-fig-$fig_file\n";
                $output_txt .= "ps2eps -f $fig_file.ps\n";
                $output_txt .= "mv $fig_file.eps ../fig/.\n";
                $output_txt .= "\n";
	}
        write_file($output_file, $output_txt);
        system("chmod 744 $output_file");
        print_message("generate_batch_to_gen_figs($output_file) OK!");
}

my (@start_time, @end_time) = ((), ());
sub begin_time()
{	@start_time	= time();	}

sub end_time()
{	@end_time	= time();	}

sub print_time_elapsed()
{
	Util::end_time();
	my $time_elapsed 	= difftime(@end_time, @start_time);
	Util::print_message("Time elapsed: $time_elapsed seconds ...");
}

1;