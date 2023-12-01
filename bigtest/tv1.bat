@echo tv1.bat
del /f fort.*
copy nbody.v452 fort.10
..\pep\pep <tv1.inp >tv1.out
if not exist tv1.vko move /y fort.64 tv1.vko
@echo exit tv1.bat