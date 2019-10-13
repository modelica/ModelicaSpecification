
ALL_G = $(wildcard *.g)
ALL_G4 = $(patsubst %.g, %.g4, $(ALL_G))
ALL_TEX = $(patsubst %.g, ../chapters/%.tex, $(ALL_G))

all: $(ALL_G4)

all_tex: $(ALL_TEX)

%.g4: %.g
	sed -e 's/{[^}]*HIDDEN[^}]*}/ -> channel(HIDDEN)/' -e 's/(options {greedy=false;} : [.])[*]/.*?/' -e '/k=3/d' $< > $@.tmp
	mv $@.tmp $@

../chapters/%.tex: %.g
	@echo off
	# delete the grammar declaration line
	sed '/lexer grammar/d' $< > $@.tmp1
	sed '/parser grammar/d' < $@.tmp1 > $@.tmp2
	# delete start_rule
	sed '/start_rule/d' < $@.tmp2 > $@.tmp1
	# remove lines containing only ;
	sed '/^[[:space:]]*;$$/d' < $@.tmp1 > $@.tmp2
	# change 'keyword' to keyword
	sed -e "s/'\([[:alpha:]]\+\)'/\1/g" < $@.tmp2 > $@.tmp1
	# ( ABC )* -> { ABC }
	perl -0777 -pi -e 's/\(([^()]*)\)\*/\{$$1\}/gms' $@.tmp1
	perl -0777 -pi -e 's/\(([^()]*)\)\*/\{$$1\}/gms' $@.tmp1
	# ABC? -> [ ABC ]
	perl -0777 -pi -e 's/(\w+)\?/\[ $$1 \]/gms' $@.tmp1
	# '?' -> "?"
	sed -e "s/'\(.\{1,2\}\)'/\"\1\"/g" < $@.tmp1 > $@.tmp2
	# "ABC"? -> [ "ABC" ]
	perl -0777 -pi -e 's/(\".\")\?/\[ $$1 \]/gms' $@.tmp2
	# ( ABC )? -> [ ABC ]
	perl -0777 -pi -e 's/\(([^()]*)\)\?/\[$$1\]/gms' $@.tmp2
	perl -0777 -pi -e 's/\(([^()]*)\)\?/\[$$1\]/gms' $@.tmp2
	# ( (ABC) )? -> [ (ABC) ]
	perl -0777 -pi -e 's/\(([^(]*\([^()]*\)[^)]*)\)\?/\[$$1\]/gms' $@.tmp2
	# change _ to - in rule names
	sed -e "s/\([^']\)_\([^']\)/\1-\2/g" < $@.tmp2 > $@.tmp1
	# echo '% generated file! DO NOT EDIT! Edit the ../grammar/.g file instead' > $@.tmp
	echo '\begin{lstlisting}[language=grammar]' >> $@.tmp
	cat $@.tmp1 >> $@.tmp
	echo '\end{lstlisting}' >> $@.tmp
	mv $@.tmp $@
	rm -f $@.tmp1 $@.tmp2 $@.tmp1.bak $@.tmp2.bak

clean:
	rm -rf *Listener*.java ModelicaLexer.java ModelicaParser.java Modelica_*.java *.tokens *.interp *.g4 *.class $(ALL_TEX)