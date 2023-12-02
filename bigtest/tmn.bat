@echo(
@echo(
del \f fort.*
copy tmn.moon fort.20
copy tmn.mrot fort.21
copy tmn.obsllr fort.24
copy tmn.ntp1 fort.41
copy tmn.ntp72 fort.42
copy nbody.v443 fort.90
..\pep\pep <tmn.inp >tmn.out
@echo(
@echo(
