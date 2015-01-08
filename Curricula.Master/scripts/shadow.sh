#!/bin/bash
set dot_input=$1
set eps_output=$2

DOT=dot
CONVERT=convert

$DOT -Tpng $dot_input.dot > tmp_all.png
$DOT -Tpng -Estyle=invis $dot_input.dot > tmp_no_edges.png
$CONVERT tmp_all.png \( tmp_no_edges.png -background black -shadow 50x3+0+5 \) +swap -background none -layers merge +repage $eps_output.png
rm -f all.png no_edges.png
open graph.png
