# ModelicaSpecification
This repository contains Modelica Language Specification (it will soon be moved to the official place ...).

How to contribute:
1. If you find an error and are not certain that you can correct it, first check that it is not already reported and then open an issue describing it in detail - focusing on why it should be changed.
2. If you are confident that you can correct the issue, fork this repository and create a pull-request and in the pull-request explain the issue and the correction; you will also have to sign a CLA.
3. Significant extensions are handled as Modelica Change Proposals. (Template to follow.) This can start as a simple description of the proposed extension. It will then be worked on to have a rationale explaining how the change help users, and demonstrating that it can be implemented efficiently; and finally a pull-request with the changes.

CLA: Contributor's license agreement. (Details to follow.)

How to edit and generate final documents
* For online editing you can use www.overleaf.com (details to follow)
* The pdf-documents are generated with pdflatex, which is part of most LaTeX installations, we used http://miktex.org/download 
* The HTML-documents are generated with LaTeXML. That is more complicated to install - and can optionally be skipped:
1. First you need perl, we used http://strawberryperl.com/
2. And then ideally the official LaTeXML package: http://dlmf.nist.gov/LaTeXML/get.html#SS4.SSS0.Px1 or https://github.com/brucemiller/LaTeXML 
3. Except that awaiting one correction we use https://github.com/HansOlsson/LaTeXML/tree/UseLabel
4. The commands used were: 

      `latexml MLS.tex --dest MLS.xml`
      
      `latexmlpost MLS.xml -format html -pmml --splitat=chapter --javascript=LatexML-maybeMathJax.js --navigationtoc=context --css=LaTeXML-navbar-left.css --dest MLS.html`
