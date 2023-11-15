@echo OFF
@echo(
@echo(
@echo Testing: tmi tv1 tv2 tin toc ttr top tfr tmn tpl tfl
@echo(
for %%s in (tmi tv1 tv2 tin toc ttr top tfr tmn tpl tfl) do (
	@echo Starting %%s
	%%s.bat
    @echo Finished %%s
	vcomp biglist.%%s %%s.out >%%s.verout
    @echo(
    @echo(
    )
