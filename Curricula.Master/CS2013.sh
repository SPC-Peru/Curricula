#!/bin/csh
# latex -interaction=nonstopmode CS2013-ES
latex CS2013-ES;
bibtex CS2013-ES1;

#       ./scripts/compbib.sh CS2013-ES > ../Curricula2015.out/log/Peru-CS2013-ES-errors-bib.txt;

latex CS2013-ES;
latex CS2013-ES;

echo CS2013-ES;
dvips CS2013-ES.dvi -o CS2013-ES.ps;
echo CS2013-ES;
ps2pdf CS2013-ES.ps CS2013-ES.pdf;
rm -rf CS2013-ES.ps;

beep;
beep;

