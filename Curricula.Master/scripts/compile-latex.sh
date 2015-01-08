#!/bin/csh

set intexfile=$1
set OutputInstDir=$2
set OutputTexDir=$OutputInstDir/tex
set OutputPdfDir=$OutputInstDir/pdf
set current_dir = `pwd`
#--END-FILTERS--

mkdir -p $OutputPdfDir

cd $OutputTexDir
rm $intexfile.ps $intexfile.dvi $intexfile.aux $intexfile.log
latex $intexfile
latex $intexfile
#latex $intexfile
dvipdfm $intexfile.dvi 
rm $intexfile.dvi $intexfile.ps $intexfile.aux $intexfile.log
cd $current_dir

mv $OutputTexDir/$intexfile.pdf $OutputPdfDir/.

