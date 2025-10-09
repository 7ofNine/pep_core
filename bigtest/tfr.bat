@echo(
@echo(
del /f fort.*
copy tfr.ctatint fort.9
copy tfr.obs fort.40
copy tfr.obspvmnc fort.41
copy tfr.obspvmdl fort.42
copy tfr.int fort.55
copy tfr.pvm09 fort.62
copy tfr.pvm13 fort.65
copy tfr.tsne fort.70
copy nbody.v311 fort.90
..\pep\pep <tfr.inp >tfr.out
@echo(
@echo(
