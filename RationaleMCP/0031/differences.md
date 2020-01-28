# Semantical differences between Flat Modelica and Modelica
This document describes differences between Flat Modelica and Modelica that aren't clear from the differences in the grammars.

## Unbalanced if-equations
In Flat Modelica, all branches of an `if`-equation must have the same equation size.
Absence of an else branch is equivalent to having an empty else branch with equation size 0.

An `if`-equation without `else` is useful for a conditional `assert` and similar checks.

Note: _The "equation size" count the number of equations as if the equations were expanded into scalar equations, 
but does not require that the equations can be expanded in this way._

### Change and reason for the change
In Modelica this restriction only applies for `if`-equations with non-parameter conditions.
For `if`-equations with parameter condition it does not hold, and if the equation sizes
differ those parameters have to be evaluated. In practice it can be complicated to separate those cases, 
and some tools attempt to evaluate the parameters even if the branches have the same equation size.

Flat Modelica is designed to avoid such implicit evaluation of parameters, and thus this restriction is necessary.

In Modelica a separate issue is that `if`-equations may contain connect and similar primitives 
that cannot easily be counted; but they are gone in Flat Modelica.

## Array dimensions with parameter variability
In Flat Modelica, an array dimension is allowed to have `parameter` variability, that is, the dimension isn't known until after solving the initialization problem in the simulation. 
Such dimension has to be specified using `:` when declaring a variable, e.g. `Real a[3,:,5];`
For short they are referred as _unknown dimension_.

Such arrays have following properties:
- There can be more then one unknown dimension.
- When checking balancing of equations and variables, they are seen as opaque and counted as one, starting from the highest (left most) unknown dimension. 
- They can be passed as arguments to functions and returned from them.
- They can be elements of records. _[this makes it really complicated]_
- Equations between them are allowed, provided the dimensions match. `:` matches only with itself.
- Unknown dimensions cannot be used to determine the iteration range of a `for`-equation, because the compiler is not able to evaluate the `size(...)` operator.
- In equations subscription into an unknown dimension is an error.
- Inside algorithms full access to the elements by subscription is possible.
- Assignments from fixed to unknown dimension is allowed, vice versa not.
- `equation` and `algorithm` sections cannot have unknown dimensions.

E.g.
```
model UnknownDimTest
Real a[3,:,5],a2[3,:,5]; // counted as 3
Real b[:,5]; // counted as 1
Real c[:]; // counted as 1
Real d[5]; // counted as 5

equation
	a=array_returning_function_call(...); // fine
	pass_array_as_function_arg(a);
	a=a2; // fine, counted as 3 equations
	b=a[1]; // fine, counted as 1 equations
	c=a2[2,:,1] // error , access into unknown dimension
	
	for i in 1:size(a,1) loop // fine
		a2[i]=a[i];  // subscription possible, but error more then one equation for a2[i] (see above a=a2)
	end for;
	
	for i in 1:size(b,1) loop // error, cannot evaluate size(b,1) at compile time
	end for;
	for i in 1:3 loop 
		c[i]=i; // error , access into unknown dimension
	end for;
	
	c=d; // error, dimension does not match
	
algorithm
	for i in 1:size(b,1) loop // fine,  size(b,1) evaluated at run time
		c[i]:=b[i,2]; // fine
	end for;
	c:=d; // fine, dimension of c will be [5] for now
	d:=c; // error, dimension does not match (assignment from unknown to fixed dimension)
end UnknownDimTest;
```
### Change and reason for the change
In Modelica variables are also allowed to have unknown to dimensions, but the handling of such is not defined. It seems to be restricted to inside functions, but this is not clearly stated.
So this is basically a clarification or maybe an extension of the Modelica specification.

The feature is useful when reading data from files (e.g. tables). These tables have to be stored in variables (i.e. initial parameters) to be used in algorithms later, but their size in not known in advance.
