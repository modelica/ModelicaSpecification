# Background
For those who don't want to read through #2211 to get the background, the application of ternary logic there is to have a `Dialog` annotation member called `visible`.  The problem with using `Boolean` is that as soon as an expression is given, it is no longer possible to say _default behavior_ (which is neither `true` nor `false`, but depends on tool-specific logic).  With a third truth value, _unknown_, it becomes possible to give an expression for selecting between:
- `false` — force hiding
- `unknown` — follow tool-specific logic (same as not specifying `visible` at all)
- `true` — force showing

# Rationale
The principles on which this MCP is base were listed on the [entry page](ReadMe.md), and are repeated here for convenience:
- A new built-in type, `Ternary`.
- A new literal constant `unknown` for the third truth value.
- Explicit as well as implicit conversion from `Boolean`.
- No implicit conversion to `Boolean`.
- No new built-in functions.

The rationale for each of these is given below.

## New built-in type
Although one could imagine ternary logic only being used in annoations to just have a pseudo code definition, and not be present in the language, it would seem like a half-baked solution.  Besides, the use of `Ternary` for expressing explicit conversion from `Boolean` solves the problem of constructing the two known truth values nicely without introducing two more literal constants.

One could also have imagined just introducing `Ternary` as a new built-in enumeration, but expressing ternary logic in analogy with Boolean logic would then require defining the meaning of Boolean operators such as `and` to have meaning for this particular enumeration.  That is probably not how we want enumerations to be used.

## New literal constant
The introduction of the keyword `unknown` to represent the third third truth value makes it very convenient to construct.  Alternatives that were considered less attractive include:
- Defining `Ternary()` to construct `unknown`.
- Defining a `Ternary`-valued operation that can produce `unknown` as a function of only known values, for example `consensus(true, false)`.

The alternative approaches both suffer from the problem of not having a symmetric way of refering to _unknown_ in the same way as we refer to `false` and `true`.  This lack of symmetry is both a problem for source code as well as in specification text and other places where writing about Modelica.

## Conversion from Boolean

### Explicit conversion
With the explicit conversion from `Boolean`, the other two `Ternary` values besides `unknown` can be expressed as `Ternary(false)` and `Ternary(true)`.  This is preferred over a solution with three new literal constants (such as {`False`, `Unknown`, `True`}), where it would be a constant source of confusion that there would be two different literals for _false_ and two different literals for _true_.

### Implicit conversion
The implicit conversion from `Boolean` to `Ternary` would be very similar to the implicit conversion from `Integer` to `Real` — a well established and everywhere used feature of Modelica.  To start with, it would mean that one would never need to write `Ternary(false)` or `Ternary(true)`; just writing `false` in a context where a `Ternary` is expected would be equivalent to writing out `Ternary(false)`, just like writing `1` is equivalent to writing `1.0` in a context where a `Real` is expected.  Then, it would also make mixing `Ternary` and `Boolean` logic seamless, so the user doesn't have to explicitly choose between either `Boolean` or `Ternary` logic for all the subexpressions that don't make use of the third truth value.  For example:
```
  parameter Ternary t;
  Real x;
  Ternary y = t or (time > 1 and x < 5); /* No need to explicitly convert conjunction to Ternary. */
```

## Conversion to Boolean

### Ternary operations resulting in Boolean
Instead of introducing conversion constructs, there are some operations on `Ternary` that can be used to express exactly what should map to `false` and what should map to `true`.  For example, `unknown == true` is defined as `true`, not `unknown`.

### No implicit conversion
To not have implicit conversion from `Ternary` to `Boolean` (such as defining the meaning of `Boolean(t)` where `t` is a `Ternary`) means that the user will always have to make an explicit choice of how to interpret a `Ternary` where a `Boolean` is required, for example in `if` conditions.  There will be no surprises of _unknown_ being treated as either `true` or `false` instead of being reported as an error.

## No built-in functions
This MCP does not include any new built-in functions, although there are several that would be natural to have.  For an example of a useful function the `consensus(t1, t2, …, tn)` would mean the common ternary value if all arguments are equal, otherwise `unknown`.

The reason for not introducing such functions is to minimize backwards incompatibility.  If the lack of such functions turns out to be too much of a limitation, they can be introduced with a future MCP.

# The option type alternative
Before deciding to go with the design where `Ternary` is introduced, we must also mention the following important alternative approach.  Reasons will be given why this isn't the design proposed by this MCP.

A completely different way of introducing ternary logic would be to introduce a `Boolean` _option_ type.  Instead of writing
```
Ternary t = unknown;
```
one would then write something like
```
Boolean? t = none;
```
where the `?` plays a similar role as an array dimension; it constructs a new type based on the type to the left.  In this case, an option type, meaning that the value of `t` is either a `Boolean` value, or a value representing the absence of a `Boolean` value.  To explicitly a known ternary value, one could have a construct like `some(true)` instead of `Ternary(true)`.

Even though the use of option types could be restricted to `Boolean` to start with, it would open up for supporting more types in the future.  Given the use case of allowing an expression of a built-in attribute to refer to the default value, it seems as if this could be useful for other types as well.  For example, pretend that the `group` of `Dialog` didn't have `"Parameters"` as fixed start value, allowing tools to organize dialogs as they see fit.  Then one could imagine giving an expression for `group` that only shall determine the group under certain circumstances, and otherwise leave it to the tool to decide.  Then the use of a `String` option would be an elegant way of making this possible.

However, these are some reasons for sticking with `Ternary` instead of `Boolean?`:
- Introducing the literal `none` to refer to the absence of a value for an option type leads to a significant change of the Modelica type system, as `none` can have any option type.  Explicitly writting out the type as in `none(Boolean)` would be too inconvenient compared to just saying `unknown`.
- Implicit conversion from `Boolean` really simplifies use of ternary logic, but implicit conversion to `Boolean?` doesn't generalize to option types in general.  (However, it works for non-option types, which might be good enough to justify it.)
- Attributes of other type than `Boolean` typically have a default behavior that can be expressed with a default value (like the empty string in case of `String`), removing the need for an option type to express the absence of a value.
- The `Boolean?` type might end up being the only special case of an option type with meanings given to the built-in operators.
- Defining external language interface for option types is a pretty big change compared to just introducing one new scalar type (it would need to be defined generically, not just with `Boolean?` in mind).
- It is probably a bad idea to just introduce option types in Modelica without considering the more general concepts that would give option types as a special case.  Such more general constructs inspired by MetaModelica have been discussed at many design meetings without getting much traction.
