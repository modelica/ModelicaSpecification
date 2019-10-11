
ALL_G = $(wildcard *.g)
ALL_G4 = $(patsubst %.g, %.g4, $(ALL_G))
ALL_TEX = $(patsubst %.g, ../chapters/%.tex, $(ALL_G))

all: $(ALL_G4)

all_tex: $(ALL_TEX)

%.g4: %.g
	sed -e 's/{[^}]*HIDDEN[^}]*}/ -> channel(HIDDEN)/' -e 's/(options {greedy=false;} : [.])[*]/.*?/' -e '/k=3/d' $< > $@.tmp
	mv $@.tmp $@

../chapters/%.tex: %.g
	echo '% generated file! DO NOT EDIT! Edit the ../grammar/.g file instead' > $@
	echo '\begin{lstlisting}[language=grammar]' >> $@
	sed -e "s/\([^']\)_\([^']\)/\1-\2/g" $< >> $@
	echo '\end{lstlisting}' >> $@

clean:
	rm -rf *Listener*.java ModelicaLexer.java ModelicaParser.java Modelica_*.java *.tokens *.interp *.g4 *.class $(ALL_TEX)