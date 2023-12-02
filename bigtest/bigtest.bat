@echo(
@echo(
@echo off
echo tmi tv1 tv2 tin toc ttr top tfr tmn tpl tfl

for %%s in (tmi tv1 tv2 tin toc ttr top tfr tmn tpl tfl) do (
	@echo Starting %%s
	%%s.bat
	@echo Finished %%s
REM	./vcomp biglist.$step $step.out >$step.verout
	@echo(
    @echo(
    )