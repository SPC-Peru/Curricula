#!/bin/csh

#--BEGIN-FILTERS--
set MainFile	= $1
set Compiler    = $2
set OutputFile  = "$3"

# ../Curricula2.0.out/Peru/CS-ANR/cycle/2012-2/Plan2012/scripts/gen-book.sh  BookOfSyllabi       	pdflatex "CS-ANR 2012-2 BookOfSyllabi (Plan2012) 1-10"

#--END-FILTERS--
set OutputInstDir=<OUTPUT_INST_DIR>
set current_dir = `pwd`

# set semester = `grep -e "\Semester}" $InfoFile | cut -d"{" -f3 | cut -d\\ -f1`
set InfoFile	= "<IN_INST_DIR>/institution-info.tex"

echo "<OUTPUT_SCRIPTS_DIR>/CompileTexFile.sh <AREA> <INST> pdflatex $MainFile $OutputInstDir"
<OUTPUT_SCRIPTS_DIR>/CompileTexFile.sh <AREA> <INST> $Compiler $MainFile "$OutputFile";

cd "<OUTPUT_HTML_DIR>";
echo "cd <OUTPUT_HTML_DIR>";
echo "pdftk A=$MainFile.pdf cat A1-1 output $MainFile-P1.pdf";
pdftk A=$MainFile.pdf cat A1-1 output $MainFile-P1.pdf;
convert $MainFile-P1.pdf $MainFile-P1.png;
rm $MainFile-P1.pdf;
cd $current_dir;

