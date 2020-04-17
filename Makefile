# Note: You should really repeat pdflatex run 1-3 times depending on status, I did not manage to make that conditional for nmake
#
# If you have latexml source (preferably with UseLabal patch) set:
#    LATEXMLPREFIX=perl <latexmlinstallation/bin>
# Otherwise we rely on the default one

all: MLS.pdf MLS.html

clean:
	rm *.aux MLS.log MLS.toc MLS.pdf
	rm MLS.xml *.html

MLS.pdf: *.tex
	pdflatex MLS.tex

# Seems to be some issue with graphicpath, so set path here as well
MLS.html: *.tex
	$(LATEXMLPREFIX)latexml MLS.tex --path=media --dest MLS.xml
	$(LATEXMLPREFIX)latexmlpost MLS.xml -format html -pmml --splitat=chapter --splitnaming=labelrelative --javascript=css/LatexML-maybeMathJax.js --navigationtoc=context --css=css/LaTeXML-navbar-left.css --dest MLS.html
