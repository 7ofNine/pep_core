@echo(
@echo(
del /f fort.*
copy top.obstop fort.14
copy nbody.v452 fort.90
..\pep\pep <top.inp >top.out
@echo(
@echo(
