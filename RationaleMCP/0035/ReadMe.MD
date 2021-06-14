Modelica Change Proposal MCP-0035
Multilingual support of Modelica
Authors: Anett Kloß, Gerd Kurzbach, Olaf Oelsner, (Thomas Beutlich)
(In Development) 
--

# Summary
Modelica currently supports only one language for description texts. This is usually English. In order to better support users from other language areas and to make Modelica libraries more attractive and easier to understand for them, it should be possible to provide translations of the texts in any language in a standardized form, so that tools can find, read and display them to the user in his or her preferred language.
The definition of the interface to the translated texts is the subject of the MCP.

In the discussion in #302 it was decided to provide the translation externally of the Modelica files using the [GNU gettext](https://www.gnu.org/software/gettext/) format. The exact use of this format in the Modelica context is described in the MCP.

# Revisions
| Date | Description |
| --- | --- |
| 2020-02-27 | Anett Kloß: Prepared document based on ticket #302 |

# Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement". 

# Rationale
Why should this feature be included? 
* A better understanding of the libraries by users with different language background will make the libraries more attractive. 
* Support cases might occur less often, due to better understanding of the description. 
* A new translation is additionally a review of the current state and can result in a better quality of both language versions.
* Users can even write their own translation, when having a template *.pot-File for the library. 

Provide at minimum two use cases for your proposal that show how it is applied. 
* POT-File of current MSL library --> this translation template is provided by ESI and filled for the Hydraulics Pump ... 
(*add picture*)
* example from Thomas Beutlich with several names in tab and group and its translation files pot and po and a picture of the result

*For each use case state how it could be implemented by current Modelica at best and why the current Modelica does not suffice for this application.*

Proposed Changes in Specification: 
* Where shall the translation file be stored (Subfolder Language in the Resources Folder)
* How does a GNU gettext translation Template for a library look like and which kind of description texts shall be included
* How does a GNU gettext translation of a library look like

The precise updated text of the specification is part of this branch/pull-request: Yes.

# Backwards Compatibility
The proposal is backwards compatible. All multilingual text changes can be applied without effect at existing Modelica code. 
After the introduction of translation files for libraries, this files need to be adjusted with every library change which adds new commented parts or changes existing comments.

# Tool Implementation

## Experience with Prototype
### Implementation steps
#### 1. Read out a translation template file \*.pot
Create at first a translation template file for a library. Means a tool dependent readout of a *LibraryName*.pot-File. The \*.pot file serves as translation template. It contains: 
- a header which concludes all necessary information
   *(insert image of header)*

- for all original strings entries with following structure: 

    msgctxt "Hydraulics.Basics.TankOverflow"
    msgid "Volume Flow Port A"
    msgstr ""

Where *msgctxt* contains the ident of the Modelica Class and *msgid* contains the textstring which is situated in this name space and shall be translated. If in this example name space the *msgid* string "Volume Flow Port A" is given more than once, all occurrences are translated with the same translation.
It shall be mandatory to use for *msgctxt* the full ident of a class:
- so a specific translation depending on the content in this namespace is possible, as every textstring may differ depending on the context,
- using the class makes it easier for the Modelica tool to copy and re-arrange models and packages without loosing the already existing language information.

The following Modelica constructs shall be read out: 
* Description / comment
* choices annotation
* missingInnerMessage, obsolete, unassignedMessage annotations
* Dialog.[group|tab] annotations
* Dialog.[load|save]Selector.[caption|filter] annotations
* Documentation.[info|revisions] annotations
* Text in diagram

Having read out the file it just needs to be changed, if the library is changed (e.g. commented parts are added or changed). 

#### 2. Translation of the template file into a language file \*.*Language*.po
Starting from the template file create a \*.po file for each needed language (e.g. german: *LibraryName*.de.po-File).

Edit the *msgstr* with the translation in the wanted language (here: `` Hydraulics.de.po``) :

    msgctxt "Hydraulics.Basics.TankOverflow"
    msgid "Volume Flow Port A"
    msgstr "Volumenstrom an Anschluss A"

Hereby no error shall occur if there is one comment not having an translation. In this case the old translation (the content of *msgid*) shall be used.
One may use the tool POedit for the translation, as it can be coupled with commercial translation tools for a faster translation. 
Again the file needs to be adjusted if there are changes at the library (e.g. commented parts are added or changed).
#### 3. File storage
Both files need to be situated in the language directory ``Resources\Language`` of the top-level library e.g.:
  ``C:\...\<ModelicaPath>\<LibraryName>\Resources\Language``
#### 4. Read in the translation
A tool dependent language setting enables the reading of the current needed *LibraryName*.*Language*.po-File.

### Tool implementation effort 
1. Readout of any comment / annotation without loosing content and with handling of exceptions, e.g. ``/"`` in comments. This can e.g. be created by the command:
``xgettext --language=EmacsLisp --sort-output --extract-all --from-code=UTF-8 --output=TranslationTest.pot TranslationTest.mo``
Certainly, the string extraction based on the EmacsLisp language can only be considered as proof of concept, since there is no Modelica language available in xgettext. It is recommended to create the POT file directly from the Modelica tool, like e.g., demonstrated by Wolfram SystemModeler or ESI ITI.
2. Import the comments with handling of exceptions ("").

# Required Patents
None. 
# References
[GNU gettext](https://www.gnu.org/software/gettext/)

[Poedit](https://poedit.net/) - useful editor 