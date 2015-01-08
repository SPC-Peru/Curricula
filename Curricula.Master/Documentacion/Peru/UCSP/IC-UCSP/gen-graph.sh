#!/bin/csh
set OutputInstDir=.
set file=IC-UCSP

echo "Generating $file.ps file ..."
dot -Gcharset=latin1 -Tps $file.dot -o $file.ps
echo "Converting ps to png ..."
convert $file.ps $file.png
echo "gen-graph done!"
