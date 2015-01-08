#!/bin/csh

set figsize     = $1    # small or big

set current_dir = `pwd`
set file=$figsize-graph-curricula

echo "Generating <OUTPUT_FIG_DIR>/$file.ps file ..."
dot -Gcharset=latin1 -Tps <OUTPUT_DOT_DIR>/$file.dot -o <OUTPUT_FIG_DIR>/$file.ps
echo "Converting ps to png ..."
convert <OUTPUT_FIG_DIR>/$file.ps <OUTPUT_FIG_DIR>/$file.png
# ps2eps <OUTPUT_FIG_DIR>/<AREA>-$figsize-graph-curricula.ps
# ps file looks fine on <AREA>-institution.pdf but eps does not ! misplaced !
# rm fig/<AREA>-<INST>-$figsize-grafo-curricula.ps
echo "gen-graph done!"
