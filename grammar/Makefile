
ALL_G = $(wildcard *.g)
ALL_G4 = $(patsubst %.g, %.g4, $(ALL_G))

all: $(ALL_G4)

%.g4: %.g
	sed -e 's/{[^}]*HIDDEN[^}]*}/ -> channel(HIDDEN)/' -e 's/(options {greedy=false;} : [.])[*]/.*?/' -e '/k=2/d' $< > $@.tmp
	mv $@.tmp $@

clean:
	rm -rf *Listener*.java ModelicaLexer.java ModelicaParser.java Modelica_*.java *.tokens *.interp *.g4 *.class