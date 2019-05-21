Modelica.g4: Modelica.g
	sed -e 's/{[^}]*HIDDEN[^}]*}/ -> channel(HIDDEN)/' -e 's/(options {greedy=false;} : [.])[*]/.*?/' -e '/k=2/d' $< > $@.tmp
	mv $@.tmp $@
