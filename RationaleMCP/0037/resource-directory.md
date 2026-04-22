# The _package-resources_ directory

Consider the following reference to an external resource:
- _modelica:/Modelica/Electrical/Analog?resource=media/foo.png_

The URI path part is the class reference, and could take different forms, as described in [modelica-uris.md](modelica-uris.md).  The referenced class is denoted _current class_, here `Modelica.Electrical.Analog`.

Here, the _media/foo.png_ is a relative file system path that is resolved within a resource directory associated with the current class.  The details of this mapping for the legacy form of a Modelica URI are omitted here; the following only applies to the non-legacy forms, when the current Modelica package is stored in a file system hierarchy:
- The fully qualified class name of the current class (after resolving any _relclass_ with respect to the class tree context) is mapped to a nested directory structure, with the constant directory name _resources.d_ (alternatively _package-resources_) appended.
- The relative file system path is relative to _resources.d_ and may not contain the special path segments "." or "..".

Note that the period (".") in the name _resources.d_ makes it distinguishable from a Modelica identifier.  In combination with the constraints on the relative file system path, this implies that that the referenced resourse resides inside the _resources.d_ directory of the class, and that any Modelica URI referencing this resource must do so via reference to the current class.

In the example Modelica URI above, assume `Modelica` is stored in _/Users/jdoe/modelica-packages/Modelica-4.3.2/Modelica_.  Then, the resolved external resource is:
- _/Users/jdoe/modelica-packages/Modelica-4.3.2/Modelica/Electrical/Analog/resources.d/media/foo.png_

Note that the mapping of the fully qualified class name to a directory is the same regardless of whether the package itself uses a directory hierarchy for storage — the directory hierarchy for external resources is fixed, and it is only one of several options for the package itself to be stored in the same hierarchy.  In particular, it does not matter whether the top level file is _package.mo_ or a file named according to the class it contains.  For example, consider the top level function `Foo` stored in _/Users/jdoe/modelica-packages/Foo.mo_.  Then this is the location of the resource _modelica:/Foo?resource=media/foo.png_:
- _/Users/jdoe/modelica-packages/Foo/resources.d/media/foo.png_

## Vendor-specific directories

Analogous to vendor-specific annotations, the directory _resources.d/\_\_NameOfVendor_ is reserved for vendor-specific use.
The _NameOfVendor_ consists of only digits and letters, and shall only convey the name of the vendor defining the meaning of the directory content.

The Modelica Association uses the vendor name _MA_.
Coordination between the different projects under the Modelica Association enables resources for both, say, the Modelica specification and the Modelica Standard Library, to coexist in this directory.

In addition to preventing conflicts between different vendors, and between vendors and library authors, the idea of vendor-specific directories might also turn out to be useful if the Modelica language would have to support "layered standards" in the future.
With one directory associated with each layered standard, it might be possible to map many layered standards to Modelica without the need for vendor-specific annotations.
At lease, any information that would be a candidate for going into a vendor-specific class annotation could go into a file associated with the class instead.

## Special resource directories

The specification is currently giving special meaning to a few external resource directores, specified using the legacy form of Modelica URIs:
- _modelica:/TopPackage/Resources/Include_
- _modelica:/TopPackage/Resources/Library_
- _modelica:/TopPackage/Resources/Source_
- _modelica:/TopPackage/Resources/Language_

As these are considered a legacy form as of this MCP, the following replacements are suggested:
- _modelica:~?resource=\_\_MA/Include_
- _modelica:~?resource=\_\_MA/Library_
- _modelica:~?resource=\_\_MA/Source_
- _modelica:~?resource=\_\_MA/Language_

By placing the directories under _\_\_MA_, there is no risk of conflict if the Modelica specification would introduce more resource directories with special meaning in the future.

To use directories associated with the top level package instead of the encapsulation barrier, there are at least two natural possibilities:
- Introduce something like a double tilde for reference to the current top level package:
  - _modelica:~~?resource=\_\_MA/Include
- Redefine the single tilde to reference the top level package rather than the encapsulation barrier.
- Revert to the old strategy of a symbolically package-dependent URI:
  - _modelica:/ModelicaLibraryName?resource=\_\_MA/Include
