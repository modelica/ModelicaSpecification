# Built-in functions and operators

## In Flat Modelica

### No discussion needed

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

### Probably should be in Flat Modelica as is

* ndims
* delay
* spatialDistribution
* homotopy
* sample
* size(A,i)
* size(A)
* scalar
* vector
* matrix
* cat

### Odd ones

* String (quite complicated function with many kinds of arguments; could be de-overloaded before Flat Modelica)
* promote (a built-in operator used to describe other operators)

### Do we need restrictions compared to Modelica?

* der
* noEvent
* smooth
* pre
* edge
* change
* reinit

### Could be implemented in Flat Modelica

Generated function names might need to be changed for different types, etc.

* EnumType(i) (indexed constant array, etc)
* Integer(enum) (easy to implement even if it could be a Flat Modelica function)
* semiLinear
* identity
* diagonal
* zeros
* ones
* fill
* linspace
* transpose
* outerProduct
* symmetric
* cross
* skew

## Only in Full Modelica

* ~~cardinality~~ (handle connections before Flat Modelica)
* ~~inStream~~ (handle connections before Flat Modelica)
* ~~actualStream~~ (handle connections before Flat Modelica)
* ~~getInstanceName~~ (handled before Flat Modelica; there is no instance name anymore)

## Reductions / Constructors

Needs to be decided. Reductions are very efficient, but some Modelica tools change ``sum(... for i in ...)`` to ``sum({... for i in ...})``

* min
* max
* sum
* product
* array
