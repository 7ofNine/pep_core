del /f fort.*
copy nbody.v443 fort.90
..\pep\pep <tmi.inp >tmi.out
if [ ! -f tmi.ales ]
then
	mv fort.87 tmi.ales
fi
if [ ! -f tmi.bles ]
then
	mv fort.88 tmi.bles
fi
if [ ! -f tmi.nbody ]
then
	mv fort.10 tmi.nbody
fi
#../peputil/abcps >tmi.abc <<'End of input'
# &INPUT NAMES=T, LOOK=4, NSERIE=999, NOPRNT=1,
#  OBSLIB=31,
# &END
#End of input
