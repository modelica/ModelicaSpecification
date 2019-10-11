
ALL_G = $(wildcard *.g)
ALL_G4 = $(patsubst %.g, %.g4, $(ALL_G))
ALL_TEX = $(patsubst %.g, %.g.tex, $(ALL_G))

all: $(ALL_G4) $(ALL_TEX)

%.g4: %.g
	sed -e 's/{[^}]*HIDDEN[^}]*}/ -> channel(HIDDEN)/' -e 's/(options {greedy=false;} : [.])[*]/.*?/' -e '/k=3/d' $< > $@.tmp
	mv $@.tmp $@

%.g.tex: %.g
	echo '\begin{lstlisting}[language=grammar]' > $@
	sed -e "s/\([^']\)_\([^']\)/\1-\2/g" $< >> $@
	echo '\end{lstlisting}' >> $@

clean:
	rm -rf *Listener*.java ModelicaLexer.java ModelicaParser.java Modelica_*.java *.tokens *.interp *.g4 *.class *.g.tex