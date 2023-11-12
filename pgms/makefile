FORT = gfortran

FFLAGS = -fno-automatic -frecord-marker=8 
B = ../bigtest
G = .
P = ../pep
U = ../peputil

new:
	$(FORT) $(FFLAGS) -c *.f

# include dependencies:
aplot.o: $U/plttyp.inc $G/pltopnfo.inc
symbol.o: $U/plttyp.inc

clean:
	rm -f *.x *.o  *.exe $U/*.o $B/*.o $P/*.o $G/*.o $B/*.exe $P/*.exe $G/*.exe