# 13.6 Multilingual Descriptions

[*Descriptive texts in a model or library are usually formulated in English. To support users who are not so familiar with this, a Modelica tool can support the translation of these texts into any language. This should be done using external files, so that no modification of the actual Modelica text is required.*]

The files to support translation must be provided by the developer of the library. They must be stored in a subdirectory of the Resources directory of the library with the name `Language`.

Two kind of files have to be provided:
* a template file `<LibraryName>.pot` (Portable Object Template). 
It contains all necessary information to translate all descriptions, but no translations. The pattern `<LibraryName>` denotes the toplevel class name of the library.
* one file for each supported language with the name `<LibraryName>.<language>.po` (Portable Object). This file is a copy of the associated template file, but extended with the translations in the specified language. The pattern `<language>` stands for the ISO 639-1 language code, e.g., de or sv.

The files consist of a header and a body. All text strings are in double quotes and encoded with UTF-8 characters. Comments start with an `#` and are continued until the end of line. Spaces outside strings are ignored and used as separators. The detailed format of these files is described in [GNU gettext](https://www.gnu.org/software/gettext/manual/gettext.pdf).

The header is marked with an empty msgid entry and looks like this:
```
# SOME DESCRIPTIVE TITLE.
# Copyright (C) YEAR THE PACKAGE'S COPYRIGHT HOLDER
# This file is distributed under the same license as the PACKAGE package.
# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.
#
#, fuzzy
msgid ""
msgstr ""
"Project-Id-Version: PACKAGE VERSION\n"
"Report-Msgid-Bugs-To: \n"
"POT-Creation-Date: 2019-03-15 10:52+0100\n"
"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\n"
"Last-Translator: FULL NAME <EMAIL@ADDRESS>\n"
"Language-Team: LANGUAGE <LL@li.org>\n"
"Language: \n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"
```
All general terms in the header should be replaced by specific information.

In the body, directly following the header, for each descriptive text there is an entry of the form
```
#: <file name>:<line number>
msgctxt "<context identifier>"
msgid "<descriptive text>"
msgstr "<translation>"
```
Only the keywords `msgctxt`, `msgid` and `msgstr` are used.

At first there can be an optional comment describing the location (file name and line number) of the text to translate. Multiple occurences of the same string can be listed here, separated by space.

Then, the `<context identifier>` behind the keyword `msgctxt` is the full name of the Modelica class (e.g. `Modelica.Blocks.Math.Sin` ) where the text appears in. Short class definitions do not appear here. Texts in such classes (including their description string) belong to the enclosing full class definition.

After the `msgid` keyword the text string which shall be translated follows. It should contain the original string from the Modelica text representation. 
Since in Modelica control sequences also start with a backslash and another backslash is used to use sequences literally or to hide double quotes, no change is required here. 
But Modelica allows strings to go over more than one line, gettext does not.
Therefore, line breaks in Modelica must be encoded with "\n" for gettext.

In order to avoid long lines Modelica strings may be split into consecutive strings at the line breaks, and the line breaks encoded with a "\n" at the end of each string, e.g.
```
"A
B"
```
is converted to
```
"A\n"
"B"
```
These strings are concatenated when read.
[*Please regard that if a `msgid` string is given more than once in the same context, all occurrences are translated with the same (last) translation!*]

The keyword `msgstr` is followed by the translation of `msgid`. With regard to control characters and line breaks, the same rules apply as for msgid. 
In the template file this string is empty by definition. If this is empty in a language specific file the contents of `msgid` may be used instead.

The texts in following Modelica constructs should be translated: 
* description strings of component declarations and classes
* strings in following annotations:
  * Text.string, Text.textString
  * missingInnerMessage, obsolete, unassignedMessage 
  * Dialog.[group|tab] 
  * Dialog.[load|save]Selector.[caption|filter] 
  * Documentation.[info|revisions]
  * Figure.title, Plot.title, Curve.legend

C-style and line comments are not translated.

[*To support the translation of these strings a number of free and commercial tools exist in context of GNU gettext. 
A Modelica tool should provide a function to create the initial template file from an existing Modelica library.*]
