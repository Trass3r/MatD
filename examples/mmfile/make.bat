@del /Q .objs
@del .deps
xfbuild +v +xstd dllmain.d dlldef.def main.d +ommfile.mexw32 -I../.. -debug -gc -unittest
@rem xfbuild +v +xcore +xstd dllmain.d dlldef.def main.d +ommfile.mexw32 -I../.. -release -O -inline