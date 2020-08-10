# Modelica URIs

The modelica URI format is extended to allow the following forms (examples and more details were included in the old email thread, and might be of interest to also include here):
- _"modelica://host/relpath"_ (non-empty host) — This is the form defined today, and should probably be deprecated.
- _"modelica:///~/relpath"_ — This is a reference to the current top level package. This is useful for organizing all resources in a hierarchy which is separate from the package hierarchy, like the current MSL.
- _"modelica:///{../}class/relpath"_ (that is, zero or more occurrences of _"../"_ followed by a classname that may be fully qualified) — Starting from the current scope, each _"../"_ moves one level up the class tree. From that location in the class tree, the class is resolved using normal lookup. A special and important case is to leave class empty, meaning a reference to the class where the lookup starts. The lookup-based rule is useful for organizing external resources with a close coupling to the classes that use them.
