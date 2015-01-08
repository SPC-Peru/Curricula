#!/bin/csh
# DEPRECATED !!!! it is already contained inside compile1institution.sh

date > out/time-<AREA>-<INST>.txt
#--BEGIN-FILTERS--
set institution=<INST>
setenv CC_Institution <INST>
set filter=<FILTER>
setenv CC_Filter <FILTER>
set version=<VERSION>
setenv CC_Version <VERSION>
set area=<AREA>
setenv CC_Area <AREA>
set CurriculaParam=<AREA>-<INST>
#--END-FILTERS--
set curriculamain=curricula-main
setenv CC_Main $curriculamain
set current_dir = `pwd`
set UnifiedMain=<UNIFIED_MAIN_FILE>
#set UnifiedMain = `echo $FullUnifiedMainFile | sed s/.tex//`

set Country=<COUNTRY>
set OutputTexDir=<OUTPUT_TEX_DIR>
set OutputHtmlDir=<OUTPUT_HTML_DIR>
set OutputScriptsDir=<OUTPUT_SCRIPTS_DIR>

./scripts/process-curricula.pl <AREA>-<INST>
<OUTPUT_SCRIPTS_DIR>/gen-eps-files.sh <AREA> <INST> <COUNTRY> <LANG>
./scripts/update-page-numbers.pl <AREA>-<INST> 
./scripts/gen-graph.sh <AREA> <INST> <COUNTRY> <LANG> big
rm <UNIFIED_MAIN_FILE>* 
./scripts/gen-html-main.pl <AREA>-<INST>

latex <UNIFIED_MAIN_FILE>
bibtex <UNIFIED_MAIN_FILE>
latex <UNIFIED_MAIN_FILE>
latex <UNIFIED_MAIN_FILE>

dvips -o <UNIFIED_MAIN_FILE>.ps <UNIFIED_MAIN_FILE>.dvi
ps2pdf <UNIFIED_MAIN_FILE>.ps <UNIFIED_MAIN_FILE>.pdf
rm <UNIFIED_MAIN_FILE>.ps <UNIFIED_MAIN_FILE>.dvi

rm -rf <OUTPUT_HTML_DIR>
mkdir -p <OUTPUT_HTML_DIR>
mkdir <OUTPUT_HTML_DIR>/figs
cp ./in/lang.<LANG>/figs/pdf.jpeg cp ./in/lang.<LANG>/figs/star.gif cp ./in/lang.<LANG>/figs/none.gif <OUTPUT_HTML_DIR>/figs/.

latex2html \
-t "Curricula <AREA>-<INST>" \
-dir "<OUTPUT_HTML_DIR>/" -mkdir \
-toc_stars -local_icons -show_section_numbers \
-address "<HTML_FOOTNOTE>" \
<UNIFIED_MAIN_FILE>
#-split 3 -numbered_footnotes -images_only -timing -html_version latin1 \

./scripts/update-analytic-info.pl <AREA>-<INST>

#<OUTPUT_TEX_DIR>/scripts/gen-syllabi.sh
mkdir <OUTPUT_HTML_DIR>/syllabi
cp <OUTPUT_TEX_DIR>/syllabi/* <OUTPUT_HTML_DIR>/syllabi/*

#Redundant withcompile1institution
# ./scripts/$area-$institution-gen-silabos

beep
beep

