#!/bin/csh

echo "CompileTexFile ..."
#--BEGIN-FILTERS--
set area	= $1
set institution	= $2
set latex_prg	= $3	#pdflatex
set MainFile	= $4   	#i.e BookOfSyllabi
set OutputFile	= "$5"
#--END-FILTERS--

set current_dir = `pwd`
echo "current_dir = $current_dir";
set OutputInstDir=<OUTPUT_INST_DIR>

if( ! -e $OutputInstDir/tex/$MainFile.tex ) then
  echo "**************************************************************************************************************************";
  echo "ERROR: There is no file: $OutputInstDir/tex/$MainFile.tex ... just ignoring it ...!";
  echo "**************************************************************************************************************************";
  exit;
endif

cd "<OUTPUT_TEX_DIR>";
set new_dir = `pwd`
# $current_dir/scripts/clean_temp_files

mkdir -p $current_dir/<OUT_LOG_DIR>;
$latex_prg $MainFile;
set compbib = "$current_dir/scripts/compbib.sh $MainFile > $current_dir/../Curricula2.0.out/log/$area-$institution-$MainFile-Errors-bib.txt"
$compbib;

$latex_prg $MainFile;
$latex_prg $MainFile;
if($latex_prg == "latex") then
  dvips $MainFile.dvi -o $MainFile.ps;
  ps2pdf $MainFile.ps $MainFile.pdf;
endif

rm *.aux  *.log *.toc *.blg *.bbl $MainFile.ps $MainFile.dvi;

echo "cd $current_dir";
cd $current_dir;

echo "cp <OUTPUT_TEX_DIR>/$MainFile.pdf <OUTPUT_HTML_DIR>"
cp <OUTPUT_TEX_DIR>/$MainFile.pdf <OUTPUT_HTML_DIR>;
echo "File <OUTPUT_HTML_DIR>/$MainFile.pdf generated !";

cp <OUTPUT_TEX_DIR>/$MainFile.pdf "../out/pdfs/$OutputFile.pdf";
echo "File ../out/pdfs/$OutputFile generated !";

