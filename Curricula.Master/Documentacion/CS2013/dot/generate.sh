#!/bin/csh
set file=cs2013

echo "Generating $file.ps file ..."
neato -Gcharset=latin1 -Tps $file.dot -o $file.ps
echo "Converting ps to png ..."
convert $file.ps $file.png
echo "Converting ps to pdf ..."
convert $file.ps $file.pdf
# ps2eps $OutputInstDir/fig/$area-$figsize-graph-curricula.ps
# ps file looks fine on $area-institution.pdf but eps does not ! misplaced !
# rm fig/$area-$institution-$figsize-grafo-curricula.ps
echo "gen-graph done!"
