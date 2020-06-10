# Note: You should really repeat pdflatex run 1-3 times depending on status, I did not manage to make that conditional for nmake
#
# If you have latexml source (preferably with UseLabal patch) set:
#    LATEXMLPREFIX=perl <latexmlinstallation/bin>
# Otherwise we rely on the default one

all: MLS.pdf MLS.html

.PHONY: clean-pdf
clean-pdf:
	rm *.aux MLS.log MLS.toc MLS.pdf

.PHONY: clean-html
clean-html:
	rm MLS.xml LaTeXML.cache *.html

.PHONY: clean
clean: clean-pdf clean-html

MLS.pdf: *.tex chapters/*.tex
	pdflatex MLS.tex

# Seems to be some issue with graphicpath, so set path here as well
MLS.html: MLS.tex chapters/*.tex
	$(LATEXMLPREFIX)latexml $*.tex --path=media --dest $*.xml
	$(LATEXMLPREFIX)latexmlpost $*.xml -format html -pmml --splitat=chapter --splitnaming=labelrelative --javascript=css/LaTeXML-maybeMathJax.js --navigationtoc=context --css=css/LaTeXML-navbar-left.css --dest $@
