#!/bin/csh
set file=cs2013

# one would process the graph and generate two output files:
dot -Gcharset=latin1 -Timap -oxs.map -Tcmapx -oxc.map -Tgif -ox.gif x.dot

# and then refer to it in a web page:

# <A HREF="x.map"><IMG SRC="x.gif" ismap="ismap" /></A>

# For client-side maps, one again generates two output files:
dot -Gcharset=latin1 -Tcmapx -oxc.map -Tgif -ox.gif x.dot

# and uses the HTML
# <IMG SRC="x.gif" USEMAP="#mainmap" />
# ... [content of x.map] ...

dot -Gcharset=latin1 -Timap -oxs.map -Tgif -ox.gif x.dot

echo "gen-graph done!"
