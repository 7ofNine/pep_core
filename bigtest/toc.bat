@echo(
@echo(
@echo(
@echo toc.bat
@echo  toc.bat depend on tv1.bat has run first
del  /f fort.*
copy tv1.vko fort.64
copy nbody.v452 fort.90
..\pep\pep <toc.inp >toc.out
@echo(
@echo(
@echo(
@echo off
rem ../peputil/abcps >toc.abc <<'End of input'
rem  &INPUT NAMES=T, LOOK=4, NSERIE=999, NOPRNT=1,
rem  OBSLIB=31,
rem &END
rem End of input
