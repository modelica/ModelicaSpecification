# Modelica Specification style guide

This is the style guide for the Modelica Specification document.


## Document format and tool chain

The source format of the document is LaTeX, and the source is processed by both pdfLaTeX and LaTeXML.
It is good to be aware of the LaTeXML implications, but for most contributors and contributions it is considered sufficient to only check that the pdfLaTeX output looks good, the idea being that potential problems should be spotted in the pull request review process.

The MSL-specific LaTeX macros and environments described in this style guide are defined in either of these two files:
- [preamble.tex](preamble.tex) – Preamble contents for the main document.
- [mlsshared.sty](mlsshared.sty) – Extracted parts of the styling to be shared with other documents that should follow the same style, such as many of the figures.


## Source code formatting

### Trailing spaces and empty lines

There shall be no trailing spaces, and each line (in particular, the last one in the file) shall be terminated by a newline.
There shall be no empty lines at the beginning or end of a file, and there shall never be more than two empty lines in a row.
Use one or two empty lines before sectioning commands such as `\section` or `\subsubsection`, except at the start of a file.
An empty line is recommended also after the non-paragraph sectioning commands.

Be careful about adding empty lines, as they actually are significant in places such as before list environments (`itemize`, etc).
For example, if the text before a list acts as an introduction, it should be kept tight with the list:
```tex
The following holds for slice operations:
\begin{itemize}
\item
    …
```

### Hard line breaks within paragraphs

The document is in ongoing transition to _one sentence per line_ source code formatting.
This means that any modified or new text should have each sentence alone on a single physical line in the source file.
Once we have the physical line breaks in the correct places, the diffs of future changes will become clean and easy to grasp, and merge conflicts much more easily resolved.

### Indentation

When indenting the contents of a LaTeX environment, an indentation of 2 spaces is used.
It is recommended to not add indentation before `\item`:
```tex
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
```tex
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
`if-equation` | `\lstinline[language=grammar]!if-equation!`{:.language-tex}

Note: The hyphenation may sometimes appear grammatically incorrect, but the consistent use of hyphenation helps readability, and in some contexts the hyphen gives extra safety against reading the language name/keyword as part of the sentence structure.
For example, compare:
- If equations are possible to simplify if their condition can be evaluated during translation.
- `if`-equations are possible to simplify if their condition can be evaluated during translation.

### Expressions

Different constructs with _expression_ and _call_:

Appearance | LaTeX source | Comment
--- | --- | ---
`if`-expression | `\lstinline!if!-expression` | Generic language concept
`DynamicSelect`-expression | `\lstinline!DynamicSelect!-expression` | Currently with space in the document!
`Curve`-expression | `\lstinline!Curve!-expression` | Currently with space in the document!
`Real` expression | `\lstinline!Real! expression` | An expression of type `Real`
`y` expression | `\lstinline!y! expression` | Expression for something named `y`
`convertElement` call | `\lstinline!convertElement! call` | A call expression with callee `convertElement`

Note: There is no need for hyphenation of "`convertElement` call" since we don't say "`Real` call" for a call expression of type `Real` (we have "`Real` expression" for this purpose).

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
As a general rule, `\firstuse` should appear in combination with `\index` for adding the term to the document index.
(The use of `\firstuse` instead of just `\emph` helps us both produce consistent formatting and makes it easier to spot cases where the additional use of `\index` has been forgotten.
The reason that `\firstuse` doesn't also do the job calling `\index` is that the form of the term presented to `\firstuse` isn't always in the base form expected in the document index, that there can be a need for special styling tricks in the `\index` argument, etc.)

If the new terminology is used before being introduced, it should be marked with `\willintroduce` (instead of `\firstuse`) to alert the reader that this is not a term that is expected to be known yet by a first-time reader.

## Miscellaneous

### Use of `\emph` and italics

To put emphasis on a word or small piece of text, use `\emph`.

Italics is used when new terminology is introduced in the running text instead of the bulkier `definition` environment, see `\firstuse` and `\willintroduce`.

Refrain from using non-semantical font switching commands for producing italics (`\textit`, `\textsl`, `\itshape`).

Note that the document is full of text set in italics, since this is used for both non-normative text and examples, through the `nonnormative` and `example` environments.

### Use of boldface

Non-semantical font switching commands for producing boldface (`\textbf`, `\bfseries`) may only be used for styling as part of higher level semantic constructs such as the _amsthm.sty_ `\newtheoremstyle` definitions.
For purposes of marking emphasis, see use of `\emph` instead.

### Ordinals

Ordinals are written with _th_ in normal font, possibly combined with a math styled expression for the number:
```tex
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

Each line should fit within the width of the page.
Use hard line breaks and manual indentation of continued lines to meet this requirement.

### Grammar (extended BNF) listings

Grammar listings use the `language=grammar`, and are written with indentation in steps of 3 spaces:
```tex
\begin{lstlisting}[language=grammar]
stored-definition :
   [ within [ name ] ";" ]
   { [ final ] class-definition ";" }
\end{lstlisting}
```

When a grammar rule is mentioned in the text, the rule shall be formatted with the _grammar_ language:
```tex
The node shall contain a \lstinline[language=grammar]!stored-definition! that…
```
