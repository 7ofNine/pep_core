@echo vcomp.bat
echo VCOMP - COMPARE TWO PEP OUTPUT LISTINGS, SUPPRESSING TRIVIAL DIFFERENCES
J:\msys64\usr\bin\sed.exe "s^ZZ1^$1^;s^ZZ2^$2^" 
REM <<'End of input' | verify
REM &CNTL  JSIZ=132, KFIN=132, IRFM=3, LCMP=3, IPUN=0  &END
REM  &CNTL  PG1ST=0,3, PG1FN=1,9999, PG2ST=0,3, PG2FN=1,9999, 
REM  FNAME='ZZ1',
REM   'ZZ2'
REM &END
REM End of input
