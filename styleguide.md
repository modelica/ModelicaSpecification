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
```
The following holds for slice operations:
\begin{itemize}
\item
    …
```

### Hard line breaks within paragraphs

The document is in ongoing transition to _one sentence per line_ source code formatting.
This means that any modified or new text should have each sentence alone on a single physical line in the source file.

When a sentence doesn't fit in one screen line, one may take that as a reminder that long sentences can reduce readability of the specification document, and consider breaking the long sentence into shorter ones.
Just keep in mind that the purpose of doing this shall be to improve readability of the specification text, not improve readability of the _one sentence per line_ formatted source code.

Once we have the physical line breaks in the correct places, the diffs of future changes will become clean and easy to grasp, and merge conflicts much more easily resolved.

### Indentation

When indenting the contents of a LaTeX environment, an indentation of 2 spaces is used.
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
Annotations are an exception to this rule.
Examples:

Appearance | LaTeX source | Comment
--- | --- | ---
`connect`-equation | `\lstinline!connect!-equation` |
`inverse` annotation | `\lstinline!inverse! annotation` |
`if`-equation | `\lstinline!if!-equation` |
`if`-expression | `\lstinline!if!-expression` |
`when`-clause | `\lstinline!when!-clause` | A branch of a `when`-equation or `when`-statement
`import`-clause | `\lstinline!import!-clause` |
`for`-equation | `\lstinline!for!-equation` |
`for`-statement | `\lstinline!for!-statement` |
`for`-loop | `\lstinline!for!-loop` | A `for`-equation or `for`-statement
`start`-attribute | `\lstinline!start!-attribute` |

Note that there's often an associated rule in the Modelica grammar, which should only be used in the text on the rare occasions when it is the actual grammar rule – not the entire language concept – that is being referenced:

Appearance | LaTeX source
--- | ---
`if-equation` | `\lstinline[language=grammar]!if-equation!`

Note: The hyphenation may sometimes appear grammatically incorrect, but the consistent use of hyphenation helps readability, and in some contexts the hyphen gives extra safety against reading the language name/keyword as part of the sentence structure.
For example, compare:
- If equations are possible to simplify if their condition can be evaluated during translation.
- `if`-equations are possible to simplify if their condition can be evaluated during translation.

### Expressions

Different constructs with _expression_ and _call_:

Appearance | LaTeX source | Comment
--- | --- | ---
`if`-expression | `\lstinline!if!-expression` | Generic language concept
parameter-expression | `parameter-expression` | Expression with parameter variability
`Real` expression | `\lstinline!Real! expression` | Expression of type `Real`
array expression | `array expression` | Expression of array type
record expression | `record expression` | Expression of record type
`y` expression | `\lstinline!y! expression` | Expression for something named `y`
`convertElement` call | `\lstinline!convertElement! call` | A call expression with callee `convertElement`

In particular, avoid other combinations of inline code and _expression_ than the variants above.
For other needs, try to find a formulation not based on _expression_ to avoid misinterpretations according to the variants above.
For example, instead of saying "… can be dependent on class variables using the `DynamicSelect` expression", just say "… can be dependent on class variables using `DynamicSelect`".

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
connection equation | `connection equation` | Equation generated from analysis of `connect`-equations
reduction expression | `reduction expression` |
base class | `base class` | Similarly: derived class
base-clock | `base-clock` | Similarly: sub-cock

## Definitions

New terminology is either introduced with a `definition` environment, or as part of the running text.
When part of the running text, the introduced terminology should be marked with `\firstuse` at the point of the definition.
As a general rule, terminology introduced with `\firstuse` should appear in the document index, and by default the mandatory argument to `\firstuse` is automatically passed to `\index`.
To change the appearance of the index entry, the default may be overridden using an optional argument to `\firstuse`, for example, `\firstuse[array!variable]{array variable}`.
This is also useful when capitalization or plural/singular differs; except for things like names, lower case should be used in the index, and terms should typically appear in the singular, for example, `\firstuse[vector]{Vectors}`.
On rare occasions, one just wants the standardized typesetting of `\firstuse` but no entry in the index, which can be achieved by passing an em-dash for the optional argument, for example, \firstuse[---]{constant}.
When suppressing the appearnce in the index, it is recommended to add a comment in the source explaining why.
It is common that the use of `\firstuse` is directly followed by additional calls to `\index` for adding the terminology in more variants to the document index.

If the new terminology is used before being introduced, it should be marked with `\willintroduce` (instead of `\firstuse`) to alert the reader that this is not a term that is expected to be known yet by a first-time reader.

## Miscellaneous

### Use of `\emph` and italics

To put emphasis on a word or small piece of text, use `\emph`.

Italics is used via the semantic macros `\firstuse` and `\willintroduce` when new terminology is introduced in the running text instead of the bulkier `definition` environment.

Refrain from using non-semantical font switching commands for producing italics (`\textit`, `\textsl`, `\itshape`).

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

## Inline code

Inline code is typically formatted using just the `\lstinline` macro.

Since the change of type face can be very hard to notice for small code fragments, single quotes may sometimes be used to emphasize the distinction from the surrounding text, unless the code fragment consists of a single identifier (consistent presentation of identifiers is given higher priority than clarity of presentation in this case).
For example:
```
… and prepending the reduction expression with ``\lstinline!functionName(!''.
```

Avoid overusing quotes around code fragments, especially for multi-letter fragments.

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
Use hard line breaks and manual additional indentation of continued lines to meet this requirement.
A semicolon in a matrix should either be followed by a line break or by a space.

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

## English natural language text

This section gives guidelines for how the natural language text in English should be written.

The text is written in American English.

### Contractions

Avoid contractions such as _isn't_ or _won't_; write _is not_ or _will/would not_ instead.

### Inline code at beginning of sentence

When a sentence starts with inline code,
> `import`-clauses are not inherited.

this may be rewritten using _The_ inserted before the inline code to avoid a lower case letter at the beginning of the sentence:

> The `import`-clauses are not inherited.

### Wrap punctuations around some abbreviations 

Always use comma (or colon if the following text starts on new line) _after_ "e.g." and "i.e."; and use comma or some other punctuation such as "(", "--", or "." before them.
This also avoids the need to guard the space after the dot.
