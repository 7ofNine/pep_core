@echo(
@echo(
@echo tmi.bat
del /f fort.*
copy nbody.v443 fort.90
..\pep\pep <tmi.inp >tmi.out
if not exist tmi.ales move /y fort.87 tmi.ales
if not exist tmi.bles move /y fort.88 tmi.bles
if not exist tmi.nbody move /y fort.10 tmi.nbody
@echo exit tmi.bat
@echo(
@echo(
@echo(
