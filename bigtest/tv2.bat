@echo tv2.bat
@echo tv2 depends on tv1 to have run first
del /f fort.*
copy nbody.v452 fort.10
copy tv1.vko fort.64
..\pep\pep <tv2.inp >tv2.out
rem../peputil/abcps >tv2.abc <<'End of input'
rem  &INPUT NAMES=T, LOOK=4, NSERIE=999, NOPRNT=1,
rem   OBSLIB=31,
rem &END
rem End of input
