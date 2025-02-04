# Rationale for relative class references

To introduce relative class references has turned out to be the most controversial part of this MCP, and therefore deserves some use cases where a fully qualified class reference is impractical.

Please note that this MCP doesn't claim that any package (the MSL in particular) should embrace the use of relative class references.  It only provides a mechanism that some library authors may find very attractive for the maintainability of Modelica URIs and the organization of external resources.

## Moving, renaming or deletion of a class

These are some examples focusing on moving, renaming, or deletion of a class.

### Class documentation refering to figures and plots of the same model

Having a fully qualified reference would introduce a completely unnecessary maintenance problem — when the class is renamed or moved, it brings both its documentation and figures along with it, but a fully qualified class reference would still refer to the old place.  With intelligent tool support, the class documentation can be automatically updated, but this is an artificial need coming from the use of fully qualified class references.

### Images belonging to the documentation of a particular class

For example, take the image
- _modelica://Modelica/Resources/Images/Blocks/Examples/PID_controller.png_

used the documentation of `Modelica.Blocks.Examples.PID_Controller`.  With this organization, moving or renaming the class has no natural connection with moving or renaming the image in the same way, meaning that the file hierarchy under _Modelica/Resources_ can easily end up outdated compared to the class tree structure.

If this image was instead referenced using the relative reference (see [modelica-uris.md])
- _modelica:?resource=Images/typical-situation.png_

it would be stored as _Modelica/Blocks/Examples/PID_Controller/resources.d/Images/typical-situation.png_.  Since the _resources.d_ directory belongs to `Modelica.Blocks.Examples.PID_Controller`, moving or renaming the class must bring along the _resources.d_ to the new location; otherwise there would be no way of referencing the resources within.  This way, the problem of keeping the structure under _Modelica/Resources_ up-to-date with the class tree structure is solved in a very simple way.

Tools don't need to be intelligent to make this work, they just need to do the bare minimum of moving the _resources.d_ along when a class is moved or renamed.  (As a bonus, the documentation in _Modelica/package.mo_ wouldn't end up with an outdated example reference to this file.)

### Data files belonging to a particular class

For example, a source block whose only purpose is to deliver the data of a particular table file.  The purpose of the block is to provide a Modelica interface to the table data, so no other model is supposed to reference the resource.  Storing the table data inside the _resources.d_ of the block defining its Modelica interface will reduce the risk of bypassing the dedicated source block, avoid having the file laying around at some location far away from the model using it, cause no problems when the model is moved or renamed, and not leave any dangling data files is the model is deleted (as the _resources.d_ should normally be removed along with the class to which it belongs).

### Experiment reference results

Imagine the possibility to have several experiments defined for the same model, where each experiment can point to an external resource with a low resolution simulation result, which can both serve as reference result and be used to show figures without first performing simulation (allowing figures to be shown as part of the model documentation instead of just being linked).  Again, such a result file is very tightly coupled to the class containing the experiment for which it serves as reference result.

Storing such results in a directory structure under _Modelica/Resources_ implies a maintenance burden, as the one-to-one relation between an experiment and its reference result leaves no excuse for not matching directory hierarchy to the class tree.  Storing such results file in the _resources.d_ of the class containing the experiment solves the maintenance problem.

## Class duplication

In addition to moving, renaming, and deletion of a class, one also have class duplication in mind.  With globally organized external resources under _Modelica/Resources_, there is no immediate need to do anything with the external resources when a class is duplicated; the new class will refer to the resources of the original class.  However, things are already starting to look strange when considering that a duplicated class (possibly a package) wouldn't be reflected under _Modelica/Resources_.  Things are then getting worse if the original class is deleted, as the resource will still be stored as if the old class still existed.  This just shows that class duplication isn't without issues in the current state of affairs.

If a tool simply makes a copy of the _resources.d_ when a class is duplicated, relative class references can offer a solution if used wisely.  When a resource is tied tightly to the class referencing it, it may not be so bad after all that one gets two different copes of the resource when the class is duplicated.  When a resource isn't tied so tightly to the class referencing it, it should be stored with a class higher up in the class tree, where the level is found by considering questions such as:
- Along with which package should the resource be deleted?
- What is the deepest common parent package of all classes where the resource is expected to be used?

## Tool implementation concerns

As neither class moving, renaming, deletion, or duplication is covered by the Modelica specification, tools are free to come up with different strategies here.  The simple approach of just moving, duplicating, or deleting _resources.d_ won't solve all problems, but as indicated above, this would be a good starting point, and can be improved by asking for user input regarding deletion and duplication.

A more ambitious tool might also automatically update relative class references that would otherwise become dangling.  Updating those that didn't become dangling would probably be bad, as these URIs were probably designed to remain unchanged when renaming, moving, or duplicating.  However, a library developer that makes clever use of relative class references is less likely to end up with dangling references, and may not even want this sort of intelligence in the tool, preferring to become aware of the dangling references so that the underlying resource organization issues can be addressed.  In other words, a tool doesn't necessarily have to be considered bad just because it only takes care of the _resources.d_ part and leaves the rest to the user.
