# Built-in functions and operators

## Flat Modelica and Modelica the same

* abs
* sign
* sqrt
* div
* mod
* rem
* ceil
* floor
* integer
* sin
* cos
* tan
* asin
* acos
* atan
* atan2
* sinh
* cosh
* tanh
* exp
* log
* log10
* initial
* terminal
* semiLinear
* identity
* diagonal
* zeros
* ones
* fill
* linspace
* delay
* spatialDistribution
* homotopy
* sample
* scalar
* vector
* matrix
* cat
* String (quite complicated function with many kinds of arguments; could be de-overloaded before Flat Modelica)
* promote (a built-in operator used to describe other operators)
* der
* noEvent
* smooth
* pre
* edge
* change
* reinit
* EnumType(i) (indexed constant array, etc)
* Integer(enum) (easy to implement even if it could be a Flat Modelica function)
* transpose
* outerProduct
* symmetric
* cross
* skew
* min
* max
* sum
* product
* array

## Might get different text to describe them

* ndims
* size(A,i)
* size(A)

Maybe also fill, etc affected?

## Only in Full Modelica

* ~~cardinality~~ (handle connections before Flat Modelica)
* ~~inStream~~ (handle connections before Flat Modelica)
* ~~actualStream~~ (handle connections before Flat Modelica)
* ~~getInstanceName~~ (handled before Flat Modelica; there is no instance name anymore)

## New in Flat Modelica
