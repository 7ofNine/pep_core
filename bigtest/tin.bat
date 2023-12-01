@echo tin.bat
del /f fort.*
copy tin.obs fort.11
copy tin.ppr fort.47
..\\pep\\pep <tin.inp >tin.out
