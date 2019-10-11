# Note: You should really repeat pdflatex run 1-3 times depending on status, I did not manage to make that conditional for nmake
#
# If you have latexml source (preferably with UseLabal patch) set:
#    LATEXMLPREFIX=perl <latexmlinstallation/bin>
# Otherwise we rely on the default one

all: MLS.pdf MLS.html

clean:
	rm *.aux MLS.log MLS.toc MLS.pdf
	rm MLS.xml *.html

MLS.pdf: *.tex chapters/*.tex # syntax
	latexmk -pdf MLS.tex

MLS.html: *.tex chapters/*.tex # syntax
	$(LATEXMLPREFIX)latexml MLS.tex --dest MLS.xml
	$(LATEXMLPREFIX)latexmlpost MLS.xml -format html -pmml --splitat=chapter --javascript=css/LatexML-maybeMathJax.js --navigationtoc=context --css=css/LaTeXML-navbar-left.css --dest MLS.html

syntax: grammar/*.g
	make -C grammar all_tex
