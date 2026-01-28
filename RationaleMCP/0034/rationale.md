# Background
For those who don't want to read through #2211 to get the background, the application of ternary logic there is to have a `Dialog` annotation member called `visible`.  The problem with using `Boolean` is that as soon as an expression is given, it is no longer possible to say _default behavior_ (which is neither `true` nor `false`, but depends on tool-specific logic).  With a third truth value, _unknown_, it becomes possible to give an expression for selecting between:
- `false` — force hiding
- `unknown` — follow tool-specific logic (same as not specifying `visible` at all)
- `true` — force showing

# Rationale
The principles on which this MCP is base were listed on the [entry page](ReadMe.md), and are repeated here for convenience:
- A new built-in type, `Ternary`.
- A new top-level constant `unknown` for the third truth value.
- Explicit as well as implicit conversion from `Boolean`.
- No implicit conversion to `Boolean`.
- No new built-in functions.

The rationale for each of these is given below.

## New built-in type
Although one could imagine ternary logic only being used in annoations to just have a pseudo code definition, and not be present in the language, it would seem like a half-baked solution.  Besides, the use of `Ternary` for expressing explicit conversion from `Boolean` solves the problem of constructing the two known truth values nicely without introducing two more literal constants.

One could also have imagined just introducing `Ternary` as a new built-in enumeration, but expressing ternary logic in analogy with Boolean logic would then require defining the meaning of Boolean operators such as `and` to have meaning for this particular enumeration.  That is probably not how we want enumerations to be used.

## New literal constant
The introduction of the top-level constant `unknown` to represent the third third truth value avoids the backwards incompatibility that would come with making `unknown` a keyword similar to `true` and `false`.  Uses that makes it distinguishable from being a keyword are deprecated from start, to pave the way for future alignment with `true` and `false`.

Alternatives that were considered less attractive include:
- Making `unknown` a keyword similar to `true` and `false`.
- Defining `Ternary()` to construct `unknown`.
- Defining a `Ternary`-valued operation that can produce `unknown` as a function of only known values, for example `consensus(true, false)`.

The alternative approaches both suffer from the problem of not having a symmetric way of refering to _unknown_ in the same way as we refer to `false` and `true`.  This lack of symmetry is both a problem for source code as well as in specification text and other places where writing about Modelica.

As shadowing the top-level `unknown` is allowed but deprecated, there can be situations where one would like to access the top-level constant while it is shadowed.  It was considered to allow something like `Ternary()` to avoid the need to access the top level constant, but the current design instead relies on using the fully qualified `.unknown`.  Use of the fully qualified form is deprecated from start, meaning that it should only be used when a model also contains the deprecated exostence of another identifier named `unknown`.

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
Instead of introducing conversion constructs, there are some operations on `Ternary` that can be used to express exactly what should map to `false` and what should map to `true`.  For example, `unknown == true` is defined as `false`, not `unknown`.

### No implicit conversion
To not have implicit conversion from `Ternary` to `Boolean` (such as defining the meaning of `Boolean(t)` where `t` is a `Ternary`) means that the user will always have to make an explicit choice of how to interpret a `Ternary` where a `Boolean` is required, for example in `if` conditions.  There will be no surprises of _unknown_ being treated as either `true` or `false` instead of being reported as an error.

## No built-in functions
This MCP does not include any new built-in functions, although there are several that would be natural to have.  For an example of a useful function the `consensus(t1, t2, …, tn)` would mean the common ternary value if all arguments are equal, otherwise `unknown`.

The reason for not introducing such functions is to minimize backwards incompatibility.  If the lack of such functions turns out to be too much of a limitation, they can be introduced with a future MCP.

## External function value mapping
In the external language interface, the `Ternary` values are mapped to {1, 2, 3}.
This makes it similar to enumerations, and by not mapping any `Ternary` value to 0 there is a better chance of detecting the mistake of directly using the `Ternary` as a truth value in the external code.

# The option type alternative
Before deciding to go with the design where `Ternary` is introduced, we must also mention the following important alternative approach.  Reasons will be given why this isn't the design proposed by this MCP.

## Using `none` to represent _unknown_
A completely different way of introducing ternary logic would be to introduce a `Boolean` _option_ type.  Instead of writing
```
Ternary t = unknown;
```
one would then write something like one of the alternatives
```
Boolean? t = Boolean?(); /* Explicit construction of the 'none' of a particular option type. */
```
or
```
Boolean? t = none; /* Using type inference to infer the particular option type. */
```
where the `?` plays a similar role as an array dimension; it constructs a new type based on the type to the left.  In this case, an option type, meaning that the value of `t` is either a `Boolean` value, or a value representing the absence of a `Boolean` value.

While the type inference alternative with `none` looks more elegant on first glance, it doesn't really fit well with current Modelica, and there is also a problem with type inference and implicit conversion that speaks to the advantage of explicitly giving the type of a _none_-value.  For the rest of this section, only the `Boolean?()` alternative for constructing the _none_-value is considered.  Explicit construction of a non-_none_ value of `Boolean?` would take the form `Boolean?(e)` where `e` is an expression of type `Boolean`.  There is thus an obvious way to define implicit conversion from any type `T` to `T?` simply by the mapping `t` → `T?(t)`, thus making the use of `Boolean?` almost as convenient as the use of `Ternary` (the difference being the keyword `unknown` vs the more cumbersome `Boolean?()`).  (To see why implicit conversion doesn't work nicely with type inference, note that the implicit conversion from `none` to `Boolean??` is ambiguous; should it be `Boolean??()` or `Boolean??(Boolean?())`.)

Even though the use of option types could be restricted to `Boolean` to start with, it would open up for supporting more types in the future.  Given the use case of allowing an expression of a built-in attribute to refer to the default value, it seems as if this could be useful for other types as well.  For example, pretend that the `group` of `Dialog` didn't have `"Parameters"` as fixed start value, allowing tools to organize dialogs as they see fit.  Then one could imagine giving an expression for `group` that only shall determine the group under certain circumstances, and otherwise leave it to the tool to decide.  Then the use of a `String` option would be an elegant way of making this possible.

Another advantage of introducing option types instead of `Ternary` would be that it would probably be acceptable to say that no option type can be used for indexing into arrays.  This would simplify parts of the implementation compared to `Ternary`.

However, these are some reasons for sticking with `Ternary` instead of `Boolean?`:
- If the usual ternary operators `not`, `and` and `or` in accordance with Kleene is what we want — which is the assumption of this MCP — the use of `Boolean?` would imply an unnatural interpretation of `none`.  [This argument is elaborated below.](#Using-none-to-represent-undefined)
- Introducing the literal `none` to refer to the absence of a value for an option type leads to a significant change of the Modelica type system, as `none` can have any option type.  Even if type inference would be implemented, there would be problems when it comes to implicit conversions (see above).
- Explicitly writting out the type of a _none_ as in `Boolean?()` would be inconvenient compared to just saying `unknown`.  (However, it would then be natural to define implicit conversion to any option type.)
- Attributes of other type than `Boolean` typically have a default behavior that can be expressed with a default value (like the empty string in case of `String`), removing the need for an option type to express the absence of a value.
- The `Boolean?` type might end up being the only special case of an option type with meanings given to the built-in logical operators.  (Possibilities to define meanings for other option types exist.  For example, one could imagine the `Real?()` and `Integer?()` both being at the same time additive zeros and multiplicative ones.  The question is whether there would ever be a need to introduce such definitions in the language.)
- Relational operators would need to be defined generically, most likely giving the order `Boolean()?` < `Boolean(false)?` < `Boolean(true)?`, which doesn't correspond to the understanding of `Boolean?()` as some kind of middle ground between false and true.
- Defining external language interface for option types is a pretty big change compared to just introducing one new scalar type (it would need to be defined generically, not just with `Boolean?` in mind).
- It is probably a bad idea to just introduce option types in Modelica without considering the more general concepts that would give option types as a special case.  Such more general constructs inspired by MetaModelica have been discussed at many design meetings without getting much traction.

## Using `none` to represent _undefined_
While possible to interpret `Boolean?()` (hereafter referred to as `none` for brevity) as _unknown_ and define logical operation on `Boolean?` in the same way as for `Ternary` to get consistency with Kleene logic, the generalization of this interpretation to other option types such as `Real?` or `String?` isn't as useful.  The natural interpretation of `none` would rather be _undefined_, which leads to more useful generalizations to other option types.

For example, one could define that concatenation with an _undefined_ `String?`, would be a no-op, and the same for addition or multiplication with an _undefined_ `Real?`.  For `Boolean?` it would then be natural to define both disjunction and conjunction with _undefined_ to be no-ops, leading to things such as `none and true = some(true)`.

Combined with `Ternary` to get `Ternary?`, one could define four-valued logic, having its own applications beyond both `Ternary` and `Boolean?`.  In detail, by identifying `true` both with `Ternary(true)` and `Boolean?(true)`, and similarly for `false`, the truth tables for `Ternary` could be reordered and extended so that they define consistent tables for all of `Boolean`, `Ternary`, `Boolean?` and `Ternary?`.  For instance, consider conjunction and let `none` refer to `Boolean?()` for brevity:

| `x and y`     | `y = none`    | `y = false` | `y = true`    | `y = unknown` |
| ------------- | ------------- | ----------- | ------------- | ------------- |
| `x = none`    | `none`        | `false`     | `true`        | `unknown`     |
| `x = false`   | `false`       | `false`     | `false`       | `false`       |
| `x = true`    | `true`        | `false`     | `true`        | `unknown`     |
| `x = unknown` | `unknown`     | `false`     | `unknown`     | `unknown`     |

Please note that this logical table does not correspond to the often cited four-valued logic by Belnap, hinting at the potential problems of reaching agreement on how to define logic on `Boolean?` and `Ternary?` in Modelica.

For the numeric types `Real` and `Integer`, a better analog to `unknown` would be `NaN` (not-a-number), having very different arithmetic behavior compared to the no-ops of _undefined_.  For example, this gives the expected behavior of adding _unknown_ to any number resulting in _unknown_.

To summarize, while option types have many interesting applications — including modeling of built-in attributes with non-trivial defaults — it would be a mistake to use `Boolean?` for the usual ternary connectives defined in accordance with Kleene.  This also shows that `Ternary` is not going to become redundant if option types are added to Modelica in the future.
