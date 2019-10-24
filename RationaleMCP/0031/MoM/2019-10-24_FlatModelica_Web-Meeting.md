Meeting Date: 10.10.2019 09:00 Location: Skype Meeting
# Participants

    Lenord Oliver (Bosch)
    Werther Kai (ETAS)
    Henrik Tildefeit (Wolfram)
    Gerd Kurzbach (ESI-ITI)
    Michael Schellenberger (ESI-ITI)
    Martin Sjölund (LiU)

# Notes

## Quoted names
Is fine, but quotes in quoted names are ugly.
Never-the-less needed to be compliant with Modelica as quoted names are allowed in Modelica.

### Conclusion:
EqCode should have an additional restriction to make it more clean, but Flat Modelica requires to support it.

## start attribute
What is the semantics of that?
An expression overrules the start value.
If there is no value or assignment, then use the start value.

We could have flat_modelica to require not to have a start value, when an expression is present.

Remove start entirely?
No, we need this for intialization.

## final modifier
Should be considered to be removed from Flat Modelica.
final is relevant for the compiler, but not for the simulation. This kind of informations should be moved to annotations.
But this kind of information really affects how the equations are transformed.
The question is when are these transformations applied?
A final parameter could be considered as constant with an annotation that tell what simplifications have been applied.

The goal is to get to a simple set of equations without loosing the information of the original model.
The semantics is applied, but the origin is preserved.

### Conclusion:
Gerd and Michael will intiate a draft pull request to the branch.

## General concept of how to convey information from the original model
### Conclusion:
Gerd and Michael: Pull request to discuss this topic, including the idea of annotations.

## Keep track of items
### Conclusions::
Henrik: Create a check list in the ReadMe.md
