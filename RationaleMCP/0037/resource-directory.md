# The _package-resources_ directory

Consider the following reference to an external resource:
- _modelica:///Modelica.Electrical.Analog/media/foo.png_

The part before _/media/foo.png_ is the class reference, and could take different forms, as described in [modelica-uris.md].  The referenced class is denoted _current class_, here `Modelica.Electrical.Analog`.

Here, the _media/foo.png_ is a relative file system path that is resolved within a resource directory associated with the current class.  The details of this mapping for the deprecated _host_ form of a Modelica URI are omitted here; the following only applies to the non-deprecated forms, when the current Modelica package is stored in a file system hierarchy:
- The fully qualified class name of the current class (after resolving any _relclass_ with respect to the class tree context) is mapped to a nested directory structure, with the constant directory name _resources.d_ (alternatively _package-resources_) appended.
- The relative file system path is relative to _resources.d_ and may not contain the special path segments "." or "..".

Note that the period (".") in the name _resources.d_ makes it distinguishable from a Modelica identifier.  In combination with the constraints on the relative file system path, this implies that that the referenced resourse resides inside the _resources.d_ directory of the class, and that any Modelica URI referencing this resource must do so via reference to the current class.

In the example Modelica URI above, assume `Modelica` is stored in _/Users/jdoe/modelica-packages/Modelica-4.3.2/Modelica_.  Then, the resolved external resource is:
- _/Users/jdoe/modelica-packages/Modelica-4.3.2/Modelica/Electrical/Analog/resources.d/media/foo.png_

Note that the mapping of the fully qualified class name to a directory is the same regardless of whether the package itself uses a directory hierarchy for storage — the directory hierarchy for external resoruces is fixed, and it is only one of several options for the package itself to be stored in the same hierarchy.
