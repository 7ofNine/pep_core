@echo(
@echo(
@echo off
del /f fort.*
copy nbody.v443 fort.90
copy ttr.sbody fort.91
..\pep\pep <ttr.inp >ttr.out
@echo(
@echo(
