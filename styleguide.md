# Modelica Specification style guide

This is the style guide for the Modelica Specification document.


## Document format and tool chain

The source format of the document is LaTeX, and the source is processed by both pdfLaTeX and LaTeXML.
It is good to be aware of the LaTeXML implications, but for most contributors and contributions is is considered sufficient to only check that the pdfLaTeX output looks good, the idea being that potential problems should be spotted in the pull request review process.


## Source code formatting

The document is in ongoing transition to _one sentence per line_ source code formatting.
This means that any modified or new text should have each sentence alone on a single physical line in the source file.
Once we have the physical line breaks in the correct places, the diffs of future changes will become clean and easy to grasp.

When indenting the contents of a LaTeX environment, an indentation of 2 spaces used.
It is recommended to not add indentation before `\item`:
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

## Formatting of language terminology

### Things with name/keyword in the language

As a general rule, when a concept is directly related to a construct in the Modelica language with a certain name/keyword, then the language concept is referred to using a hyphenated combination of the language name/keyword in code style, with a qualifying natural language word written as normal text.
Examples:

Appearance | LaTeX source
--- | ---
`connect`-equation | `\lstinline!connect!-equation`
`if`-equation | `\lstinline!if!-equation`
`if`-expression | `\lstinline!if!-expression`
`when`-clause | `\lstinline!when!-clause`
`start`-attribute | `\lstinline!start!-attribute`

Note that there's often an associated rule in the Modelica grammar, which should only be used in the text on the rare occasions when it is the actual grammar rule – not the entire language concept – that is being referenced:

Appearance | LaTeX source
--- | ---
`if-equation` | `\lstinline[language=grammar]!if-equation!`

Note: The hyphenation may sometimes appear grammatically incorrect, but the consistent use of hyphenation helps readability, and in some contexts the hyphen gives extra safety against reading the language name/keyword as part of the sentence structure.
For example, compare:
- If equations are possible to simplify if their condition can be evaluated during translation.
- `if`-equations are possible to simplify if their condition can be evaluated during translation.

### The keywords themselves

When referencing a keyword itself, hyphenation is not used, and when possible, a better describing word than _keyword_ is used:

Appearance | LaTeX source | Comment
--- | --- | ---
the `input` prefix | `\lstinline!prefix! prefix` | For more prefixes, see `class-prefixes`, `base-prefix`, and `type-prefix` in the grammar.
the `final` modifier | `the \lstinline!final! modifier` |
the `each` keyword | `the \lstinline!each! keyword` |

Depending on context, one can also swap the order, or drop the describing word completely:

Appearance | LaTeX source
--- | ---
the keyword `each` | `the keyword \lstinline!each!`
declared as `final` | `declared as \lstinline!final!`

### Named functions and operators

When referencing a named function of operator, hyphenation is not used, and it is common to not combine with any describing word:

Appearance | LaTeX source
--- | ---
the `smooth` operator | `the \lstinline!smooth! operator`
where `pre` is not explicitly used | `where \lstinline!pre! is not explicitly used`

### Other things, special cases

Incomplete list of various terminology with special formatting rules:

Appearance | LaTeX source | Comment
--- | --- | ---
start value | `start value` | Value of the `start`-attribute (there could be exceptions!)
reduction expression | `reduction expression` |
base class | `base class` | Similarly: derived class
base-clock | `base-clock` | Similarly: sub-cock

## Definitions

New terminology is either introduced with a `definition` environment, or as part of the running text.
When part of the running text, the introduced terminology should be marked with `\firstuse` at the point of the definition.
(The use of `\firstuse` helps us both produce consistent formatting and keep track of things that should appear in the document index.)

If the new terminology is used before being introduced, the first use should be marked with `\willintroduce` to alert the reader that this is not a term that is expected to be known yet by a first-time reader.

## Miscellaneous

### Use of `\emph` and italics

To put emphasis on a word or small piece of text, use `\emph`.

Italics is used when new terminology is introduced in the running text instead of the bulkier `definition` environment, see `\firstuse` and `\willintroduce`.

Non-semantical font switching commands for producing italics (`\textit`, `\textsl`, `\itshape`) should pretty much never be used.

Note that the document is full of text set in italics, since this is used for both non-normative text and examples, through the `nonnormative` and `example` environments.

### Use of boldface

Non-semantical font switching commands for producing boldface (`\textbf`, `\bfseries`) may only be used for styling as part of higher level semantic constructs such as the _amsthm.sty_ `\newtheoremstyle` definitions.
For purposes of marking emphasis, see use of `\emph` instead.

### Ordinals

Ordinals are written with _th_ in normal font, possibly combined with a math styled expression for the number:
```
Fixed ordinals: 1st, 2nd, 3rd.
Symbolic ordinals: $n$th, $(n+1)$th.
```

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
