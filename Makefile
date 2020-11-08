# Note: Using latexmk, since it automatically runs pdflatex as many times as needed.
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
	latexmk -pdf MLS.tex

# Seems to be some issue with graphicpath, so set path here as well
# Not using %.html since nmake does not support it (instead using old-style suffix rules)
MLS.html: MLS.tex chapters/*.tex
	$(LATEXMLPREFIX)latexml MLS.tex --path=media --dest MLS.xml
	$(LATEXMLPREFIX)latexmlpost MLS.xml -format html -pmml --splitat=chapter --splitnaming=labelrelative --javascript=css/LaTeXML-maybeMathJax.js --navigationtoc=context --css=css/MLS.css --css=css/MLS-navbar-left.css --dest $@
