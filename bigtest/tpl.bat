@echo(
@echo(
@echo tpl.bat
del /f fort.*
copy nbody.v443 fort.90
copy tpl.ut fort.93
copy tpl.xy fort.94
..\\pep\\pep <tpl.inp >tpl.out
@echo(
@echo(
@echo(