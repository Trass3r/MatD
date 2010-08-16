@del /Q .objs
@del .deps
xfbuild +v +xcore +xstd matcreate.d +omatcreate -I..\..\.. -debug -g -unittest

@del /Q .objs
@del .deps
xfbuild +v +xcore +xstd matdiag.d +omatdiag -I..\..\.. -debug -g -unittest

@del /Q .objs
@del .deps
xfbuild +v +xcore +xstd engdemo.d +oengdemo -I..\..\.. -debug -g -unittest

pause