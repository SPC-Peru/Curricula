package MallaUtils;

use 5.008008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use MallaUtils ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{$EXPORT_TAGS{'all'} } );

our @EXPORT = qw($VERSION,%curso_info, %cursos_por_semestre, %colors
);

our $VERSION = '0.01';
our %curso_info;
our %cursos_por_semestre;
our %colors = (	"CS"=> "white",
              	"HU"=> "blue",
         	"ET"=> "green",
         	"CB"=> "white");

# Preloaded methods go here.

sub new 
{
  my $package = shift;
  return bless({}, $package);
}

sub parse($)
{
   my $filename = (@_);
   open(IN, "<$filename") or die "Enable to open $filename";
   while(<IN>)
   {
      if( m/^\\curso{(.*)}{(.*)}{(.*)}{(.*)}{(.*)}{(.*)}{(.*)}{(.*)}{(.*)}{(.*)}%(.*)/)
      {
         my ($semestre, $tipo, $codigo, $nombre) = ($1, $2, $3, $4);
         my ($ht, $hp, $hl, $creditos)           = ($5, $6, $7, $8);
         my $requisitos                          = $9;
         my $topicos                             = $10;
	 my $inst_list 				 = $11;
         my @reqarray = split ",",$requisitos;
         my $color = "";
         if($codigo =~ m/(..).*/)
         {
            $color = $colors{$1};
         }
         if(not defined($cursos_por_semestre{$semestre}))
         {
            $cursos_por_semestre{$semestre} = [];
         }
         push(@{$cursos_por_semestre{$semestre}}, $codigo);

	 if( defined($curso_info{$codigo}) )
	 {
		#print "El codigo de curso $codigo esta duplicado\n";
	 }
         $curso_info{$codigo}{semestre}   = $semestre;
         $curso_info{$codigo}{tipo}       = $tipo;
         $curso_info{$codigo}{color}      = $color;
         $curso_info{$codigo}{nombre}     = $nombre;

         $curso_info{$codigo}{ht}         = 0;
         if( not $ht eq "" )
         {  $curso_info{$codigo}{ht}         = $ht;}

         $curso_info{$codigo}{hp}         = 0;
         if( not $hp eq "" )
         {  $curso_info{$codigo}{hp}         = $hp;}

         $curso_info{$codigo}{hl}         = 0;
         if( not $hl eq "" )
         {  $curso_info{$codigo}{hl}         = $hl;}


         $curso_info{$codigo}{cr}         = $creditos;
         $curso_info{$codigo}{requisitos} = "";
         $curso_info{$codigo}{fullrequisitos} = $requisitos;
         $curso_info{$codigo}{topicos}    = $topicos;

	 #laboratorio
	 if( $curso_info{$codigo}{hl} > 0 )
	 {
		#print "\\section{";
		#print "$codigo. $curso_info{$codigo}{nombre} ($curso_info{$codigo}{tipo}) ";
		#print "$curso_info{$codigo}{semestre}";
		#print "\$^{$rom_postfix{$curso_info{$codigo}{semestre}}}\$ Sem., ";
		#print "Lab: $curso_info{$codigo}{hl} hr(s)";
		#print "}\n\%Lab\n\n\n";
	 }
         my $enter = "";
         foreach my $req (@reqarray)
         {
            $curso_info{$codigo}{requisitos} .= "$enter$req";
            $enter = " ";
         }
	 $curso_info{$codigo}{inst_list} = $inst_list;
      }
      elsif( m/^((\t|\s)*)$/)
      {
         next;
      }
      elsif( m/^%.*/)
      {
         next;
      }
      else
      {
         print "No encaja \"$_\"\n";
      }
   }
   close(IN);
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

MallaUtils - Perl extension for blah blah blah

=head1 SYNOPSIS

  use MallaUtils;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for MallaUtils, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Ernesto Cuadros, E<lt>ecuadros@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Ernesto Cuadros

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
