#!/bin/csh
set intexfile   = $1    # intexfile
set outfile     = $2    # outtexfile
set workingdir  = $3    # directory
set current_dir = `pwd`

# <OUTPUT_SCRIPTS_DIR>/compile-simple-latex.sh Computing-poster <AREA>-<INST>-poster .<OUTPUT_TEX_DIR>;

cd $workingdir;
rm $intexfile.ps $intexfile.dvi $intexfile.aux $intexfile.log;
latex $intexfile;
latex $intexfile;
#latex $intexfile;
dvips -P a0 $intexfile.dvi -o;
ps2pdf $intexfile.ps $intexfile.pdf;
rm $intexfile.dvi $intexfile.aux $intexfile.log;
cd $current_dir;
#rm $workingdir/$intexfile.ps
mv $workingdir/$intexfile.pdf <OUTPUT_HTML_DIR>/$outfile.pdf;


