@echo(
@echo(
del -f fort.*
copy tfl.w0 fort.60
copy tfl.w0 fort.61
rem chmod u+w fort.60 fort.61
copy tfl.obs fort.50
copy tfl.smat fort.65
copy nbody.v311 fort.90
..\pep\pep <tfl.inp >tfl.out
@echo(
@echo(
