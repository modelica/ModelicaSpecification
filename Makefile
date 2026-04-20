# Note: Using latexmk, since it automatically runs pdflatex as many times as needed.
#
# If you have latexml source (preferably with UseLabal patch) set:
#    LATEXMLPREFIX=perl <latexmlinstallation/bin>
# Otherwise we rely on the default one

all: MLS.pdf MLS.html

.PHONY: clean-pdf
clean-pdf:
	-rm MLS.pdf MLS.log *.out *.aux chapters/*.aux *.toc *.fls *.bbl *.bcf *.blg *.run.xml *.idx *.ilg *.ind

.PHONY: clean-html
clean-html:
	-rm MLS.xml LaTeXML.cache MLS.fdb_latexmk *.html *.css *.js

.PHONY: clean
clean: clean-pdf clean-html

MLS.pdf: *.tex chapters/*.tex
	latexmk -pdf MLS.tex

# Seems to be some issue with graphicpath, so set path here as well
# Not using %.html since nmake does not support it (instead using old-style suffix rules)
# The --preload flag is a workaround proposed in the following LaTeXML issue:
# - https://github.com/brucemiller/LaTeXML/issues/2553 -- fixed on 'master' as of 2025-05-07
index.html: MLS.tex chapters/*.tex
	$(LATEXMLPREFIX)latexml MLS.tex --preload=[nobreakuntex]latexml.sty --includestyles --path=media --dest MLS.xml
	$(LATEXMLPREFIX)latexmlpost MLS.xml -format html -pmml --splitat=chapter --splitnaming=labelrelative --javascript=LaTeXML-maybeMathjax.js --navigationtoc=context --css=css/MLS.css --css=css/MLS-navbar-left.css --dest $@
	.scripts/patch-viewport.sh
	.scripts/patch-body-ios-hover.sh
