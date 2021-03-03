# Modelica Specification style guide

This is the style guide for the Modelica Specification document.


## Document format and tool chain

The source format of the document is LaTeX, and the source is processed by both pdfLaTeX and LaTeXML.
It is good to be aware of the LaTeXML implications, but for most contributors and contributions is is considered sufficient to only check that the pdfLaTeX output looks good, the idea being that potential problems should be spotted in the pull request review process.


## Source code formatting

The document is in ongoing transition to _one sentence per line_ source code formatting.
This means that any modified or new text should have each sentence alone on a single physical line in the source file.
Once we have the physical line breaks in the correct places, the diffs of future changes will become clean and easy to grasp.

When indenting the contents of a LaTeX environment, an indentation of 2 spaces used.  It is recommended to not add indentation before `\item`:
```
\begin{itemize}
\item
  First are all inputs to the original function, and after all them we will in order append one derivative for each input containing reals.
  These common inputs must have the same name, type, and declaration order for the function and its derivative.
\item
  The outputs are constructed by starting with an empty list and then in order appending one derivative for each output containing reals.
  The outputs must have the same type and declaration order for the function and its derivative.
\end{itemize}
```

Many environments are used without indenting the contents, including `nonnormative` and `example`:
```
\begin{nonnormative}
This means that the most restrictive derivatives should be written first.
\end{nonnormative}
```

## Special terminology

**TODO**: Sort out the following situation, reported in https://github.com/modelica/ModelicaSpecification/issues/2713:

Space | Hyphen | Inline code | Both
--- | --- | --- | ---
connect equation (9) | connect-equation (32) | `connect` equation (5) | `connect`-equation (2)
when clause (5) | when-clause (86) | `when` clause (0) | `when`-clause (11)
if equation (0) | if-equation (8) | `if` equation (0) | `if`-equation (0)
start value (24) | start-value (15) | `start` value (5) | `start`-value (2)


## Miscellaneous

### Ordinals

Ordinals are written with _th_ in normal font, possibly combined with a math styled expression for the number:
```
Fixed ordinals: 1st, 2nd, 3rd.
Symbolic ordinals: $n$th, $(n+1)$th.
```

### Use of `\emph` and italics

**TODO**


### Use of boldface

**TODO**


## Code listings

### Modelica listings

Modelica listings are written with indentation in steps of 2 spaces.

A space is typically added on each side of a binary operator, and after comma.

Code snippets may start with an indented line as long as there's some line in the listing with zero indentation, like this:
```
  Real x(start = 1.0, fixed = true);
equation
  der(x) = -x;
```

Each line should fit within the width of the page, using hard line breaks and manual indentation of continued lines to meet this requirement.

### Grammar (extended BNF) listings

Grammar listings use the `language=grammar`, and are written with indentation in steps of 3 spaces:
```
\begin{lstlisting}[language=grammar]
stored-definition :
   [ within [ name ] ";" ]
   { [ final ] class-definition ";" }
\end{lstlisting}
```

When a grammar rule is mentioned in the text, the rule shall be formatted with the _grammar_ language:
```
The node shall contain a \lstinline[language=grammar]!stored-definition! that…
```
