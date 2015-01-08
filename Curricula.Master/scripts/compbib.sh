#!/bin/csh
set main=$1

# set current_dir = `pwd`;
# echo "current_dir = $current_dir";
# echo "main=$main";

foreach tmp ($main*.aux)
   set auxfile = `echo $tmp | sed s/.aux//`
   echo bibtex $auxfile
   bibtex $auxfile
end
