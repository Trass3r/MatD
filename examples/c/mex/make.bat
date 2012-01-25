rdmd --build-only --chatty -I..\..\.. -release -O -inline dllmain.d dlldef.def -ofarrayProduct.mexw32 arrayProduct.d
rdmd --build-only --chatty -I..\..\.. -release -O -inline dllmain.d dlldef.def -ofarrayProductFOR.mexw32 arrayProductFOR.d
rdmd --build-only --chatty -I..\..\.. -release -O -inline dllmain.d dlldef.def -ofexplore.mexw32 explore.d
pause
