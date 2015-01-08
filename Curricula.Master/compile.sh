#!/bin/csh

set acro=$1 # CS-SPC
./scripts/gen-scripts.pl $acro

./compile1institucion.sh Yes Yes
beep
beep
