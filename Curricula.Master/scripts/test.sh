#!/bin/csh

#--BEGIN-FILTERS--
./scripts/gen-book.sh CS UCSP Peru BookOfSyllabi       	pdflatex
cp ./out/Peru/CS-UCSP/tex/syllabi/BookOfSyllabi.pdf ./out/Peru/CS-UCSP/html/syllabi/.
cp ./out/Peru/CS-UCSP/tex/syllabi/BookOfSyllabi.pdf "out/pdfs/CS-UCSP 2012-1 BookOfSyllabi (Plan2006) 3-3.pdf"
rm ./out/Peru/CS-UCSP/tex/syllabi/BookOfSyllabi.pdf

