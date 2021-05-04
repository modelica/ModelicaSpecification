# Example “manifest.xml” file

This is an example of what the “manifest.xml” file could look like for
an example encrypted library:

&lt;?xml version=*"1.0"* encoding=*"utf-8"*?&gt;

&lt;archive&gt;

&lt;!-- All paths in the file are interpreted as relative to the
directory of the top-level

package (e.g., the path to this file would be ".library/manifest.xml"),
and allows

only forward slashes as directory separators. --&gt;

&lt;manifest version=*"1.0"*/&gt;

&lt;!-- The id attribute is the actual Modelica identifier of the
library. The file attribute

from SMA is no longer needed, as it will always be "package.mo" or
"package.moc"

(and the tool will need the logic of checking for both .mo and .moc
anyway).

The enabled attribute (optional, default value is true) indicates
whether the library

should be enabled/loaded by default. --&gt;

&lt;library id=*"ExampleLib"* enabled=*"true"*&gt;

&lt;!-- Official title of the library (optional) --&gt;

&lt;title&gt;Example Encrypted Library&lt;/title&gt;

&lt;!-- Description (optional) --&gt;

&lt;description&gt;

Dummy library showing directory structure for an encrypted library (with
empty files)

&lt;/description&gt;

&lt;!-- The version of the library. Version information is formatted
according to the

Modelica language specification. The build and date attributes are
optional. --&gt;

&lt;version number=*"1.0"* build=*"1"* date=*"2013-08-04"*/&gt;

&lt;!-- Version of the Modelica language that is used in this library.
--&gt;

&lt;language version=*"3.2"* /&gt;

&lt;!-- Copyright notice (optional)--&gt;

&lt;copyright&gt;

Copyright © 2014, Modelon AB.

&lt;/copyright&gt;

&lt;!-- License information (optional) --&gt;

&lt;license&gt;

Some license information.

&lt;/license&gt;

&lt;!-- Encryption/license check information (only for proprietary
libraries).

If this is present, then the library is encrypted. --&gt;

&lt;encryption&gt;

&lt;!-- Library vendor executable. May be repeated - one for each
supported platform.

path: the path to the executable

platform: the OS/platform to use this executable on, must be unique
among

executable nodes

licensing: if this executable handles licensing (optional, default is
true)

The executable shall be placed under the vendor-specific directory

(i.e. .library/VENDORNAME/). The normal case is that licensing has the
same

value for each executable node, but it is allowed to have different
values

for different platforms. --&gt;

&lt;executable path=*".library/Modelon/vendor.exe"* platform=*"win32"*
licensing=*"true"* /&gt;

&lt;executable path=*".library/Modelon/vendor32"* platform=*"linux32"*
licensing=*"true"* /&gt;

&lt;executable path=*".library/Modelon/vendor64"* platform=*"linux64"*
licensing=*"true"* /&gt;

&lt;/encryption&gt;

&lt;!-- Icon for the library (PNG format) (optional) --&gt;

&lt;icon file=*"Resources/Images/el.png"* /&gt;

&lt;/library&gt;

&lt;!-- Leaving out optional compatibility and dependencies in this
example. --&gt;

&lt;/archive&gt;
