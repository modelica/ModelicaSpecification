# The _package-resources_ directory

When mapping the forms with empty host to a resource location, each identifier of the fully qualified class name is mapped to a subdirectory level of the external resource hierarchy (in the same way as the old form with host), where the _relpath_ is resolved within the directory _package-resources_ (alternatively _resources.d_).

Unlike the old form with host, there is no restriction on the first part of _relpath_.  However, in the same spirit, the _relpath_ is not allowed to reference anything outside the _package-resources_ directory, so that the only way a Modelica URI can reference a resource is by referencing the class to which the _package-resources_ directory belongs.
