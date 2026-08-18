# Base Modelica External Function Interface (proposal)

> Author: Andreas Heuermann, Santa Anna IT Research, Sweden

This proposal covers how to deal with [Modelica 12.9 External Function Interface][msl-12.9-ext-func-interface] and [Modelica 12.9.8 External Objects][msl-12.9.8-ext-obj] in Base Modelica by taking core ideas from FMU Distribution in [FMI 3.0.x][fmi-3.0.x] and ending up at a FMU like directory layout.

## Overview

### Rationale

There are three distinct options to go forward with Base Modelica and external functions:

1. Don't allow external functions in Base Modelica at all.
2. Allow external functions in Base Modelica (current status).
    - Don't bundle external functions with Base Modelica.
    - Bundle external functions with Base Modelica.

Many high grade industrial Modelica libraries rely heavily on external C code.
Therefore Base Modelica needs to support external functions for any practical application for those libraries.

One desired use case for Base Modelica is to utilize a Modelica tool's simplification and index reduction capabilities to get a reduced Base Modelica version of a Modelica model.
If that model happens to use external functions, a complete Base Modelica "package" also needs to include those external functions.
This has to be done in a way that can be automated by a tool lowering Modelica to Base Modelica.

If a Base Modelica file that uses external functions is shared, the importing system needs to have the external functions available in some way.
This could mean installing a bunch of Modelica libraries that provided the external functions or getting a loose collection of source/binary files the importer has to save in the right locations.
This is exactly the kind of issue the [FMI standard][fmi-standard] already solved.
With a possible layered standard [FMI-LS-REF][fmi-ls-ref] it would even be possible to share the governing Modelica *and* Base Modelica files bundled nicely together with all the binaries (or sources) needed for the external functions.

The following describes one way to bundle Base Modelica models with their used external functions without going the full [FMI-LS-REF][fmi-ls-ref] way.

### Goals

- Be expressive enough to convert Modelica external functions and external objects in its entirety:
  - C compatibility
  - Mapping of argument types from Base Modelica to target language and back
  - Cover external objects
- Be as simple as possible:
  - *Don't allow* arbitrary parameter order for the external function
  - *Only allow* a specific location for bundled external functions
  - *Only allow* binaries for external libraries
  - Drop FORTRAN support

### Related

- Require that external functions have explicit external call ([Pull Request #3637][modelica-pull-3637])
- Flat Modelica and External or Vendor-specific Functions ([Issue #2584][modelica-issue-2584])

## External Function

### Type Mapping

Base Modelica uses the same mapping to C as specified by [Modelica 12.9.1 Argument Type Mapping][msl-12.9.1-arg-type-mapping] and [12.9.2 Return Type Mapping][msl-12.9.2-ret-type-mapping].

> [!IMPORTANT]
> FORTRAN 77 is dropped for simplicity and because of the record exception.
> It can easily be added to Base Modelica or C wrappers can be used instead.

| Modelica             | C input                                | C output                         | C return type     |
|----------------------|----------------------------------------|----------------------------------|-------------------|
| `Real`               | `double`                               | `double *`                       | `double`          |
| `Integer`            | `int`                                  | `int *`                          | `int`             |
| `Boolean`            | `int`                                  | `int *`                          | `int`             |
| `String`             | `const char *`                         | `const char **`                  | `const char *`    |
| `T[dim1]`            | `const T' *, size_t dim1`              | `T' *, size_t dim1`              | not allowed       |
| `T[dim1, dim2]`      | `const T' *, size_t dim1, size_t dim2` | `T' *, size_t dim1, size_t dim2` | not allowed       |
| `T[dim1, ..., dimN]` | `const T' *, ..., size_t dimN`         | `T' *, ..., size_t dimN`         | not allowed       |
| Enumeration          | `int`                                  | `int *`                          | `int`             |
| Record               | `struct *`                             | `struct *`                       | `struct` by value |

`Boolean` maps to `int`: `false` → 0, `true` → 1.

An argument of the form `size(…, …)` maps to `size_t` instead.

`String` values must be NUL-terminated; a returned `String` must be either a string input, a C string literal, or a pointer from one of the Modelica string allocation utilities.

### Aliasing

Keep the restriction on changing inputs in external functions.

> An external function is not allowed to internally change the inputs (even if they are restored before the end of the function).
>
> From [Modelica 12.9.3 Aliasing][msl-12.9.3-aliasing]

### Annotations for External Functions

Annotations from [Modelica 12.9.4 Annotations for External Functions][msl-12.9.4-annotations] do the heavy lifting for collecting the actual external functions.

In Base Modelica only binary distribution is supported, so `Include`, `IncludeDirectory`, and `SourceDirectory` are dropped.

> [!NOTE]
> `Include`, `IncludeDirectory`, and `SourceDirectory` can be re-added later on

The `modelica:/` URI scheme is replaced by `base-modelica:`, which is always relative to the directory of the current Base Modelica file, removing any dependency on package path lookups.

The following annotations are allowed on the `external`-clause:

| Annotation         | Type                    | Required | Description                                          |
|--------------------|-------------------------|----------|------------------------------------------------------|
| `Library`          | `String` or `String[:]` | yes      | Library name(s) to link, without prefix or suffix    |
| `LibraryDirectory` | `String`                | yes      | Location of the library files (`base-modelica:` URI) |
| `License`          | `String`                | no       | Path to the license file for the bundled library     |

Both `Library` and `LibraryDirectory` must always be present explicitly in the annotation — no defaults are provided.
Using the model name as part of the `LibraryDirectory` path (e.g. `base-modelica:ExternalFunctions1_Example/Library`) is recommended to prevent naming conflicts between libraries from different models that happen to share a library name.
If two distinct external C libraries within the same model share a filename (e.g. both produce a shared library with the same filename), each must be placed in a separate subdirectory and annotated accordingly, e.g. `base-modelica:ExternalFunctions1_Example/Library1/Library` and `base-modelica:ExternalFunctions1_Example/Library2/Library`.

The tool resolves the library by appending the platform tuple (e.g. `win64`, `linux64`, ..) as a subdirectory of `LibraryDirectory`.
The platform subdirectory is mandatory; placing libraries directly in `LibraryDirectory` is not allowed.

```modelica
function ExternalFunc1
  input Real x;
  output Real y;
external "C"
  y = ExternalFunc1_ext(x)
    annotation(
      Library          = "ExternalLib1",
      LibraryDirectory = "base-modelica:ExternalFunctions1_Example/Library",
      License          = "base-modelica:ExternalFunctions1_Example/licenses/ExternalLib1.txt"
    );
end ExternalFunc1;
```

The files on disk next to the `.bmo` file:

```text
ExternalFunctions1.Example.bmo
ExternalFunctions1_Example/
├── Library/
│   ├── x86_64-linux/
│   │   ├── libExternalLib1.a
│   │   └── libExternalLib2.so
│   └── x86_64-windows/
│       ├── ExternalLib1.lib
│       ├── ExternalLib2.lib
│       └── ExternalLib2.dll
└── licenses/
    ├── ExternalLib1.txt
    └── ExternalLib2.txt
```

#### Alternative Mandatory Resources Layout

> Instead of a suggestion where resources *could* live it is mandatory that all parts of a Base Modelica model *must* live in a specific structure.
> An additional advantage is that this would also result in a natural location for other accompanying files like license or documentation files and clear what files need to be collected to share with another person.

A Base Modelica file **must** live in a directory with the same name as the Base Modelica package identifier.
URI `base-modelica` is always pointing to directory `Resources` directly next to the Base Modelica file, removing any dependency on complex package path lookups.

```modelica
function 'PackageA.ExternalFunc1' "Include header file for library implementation"
  input Real 'x';
  output Real 'y';
external "C" 'y' = ExternalFunc1_ext('x') annotation(
  Library = "ExternalLib1",
  LibraryDirectory = "base-modelica:PackageA/Library");
end 'PackageA.ExternalFunc1';
```

A short example of the mandatory structure for Base Modelica package `AlternativeStructure`:

```text
AlternativeStructure
├── AlternativeStructure.bmo
├── Documentation
│   └── how-to-use.pdf
├── LICENSE.txt
└── Resources
    ├── PackageA
    │   └── Library
    │       └── linux64
    │           ├── libExternalLib1.a
    │           └── libExternalLib2.so
    └── PackageB
        └── Library
            └── linux64
                └── libExternalLib1.a
```

### Example

Lowering of Modelica model `Example`, which uses functions from two Modelica packages.

#### Modelica Input

*PackageA/package.mo:*

```modelica
package PackageA

  function ExternalFunc1 "Include header file for library implementation"
    input Real x;
    output Real y;
  external "C"
    y = ExternalFunc1_ext(x)
      annotation(
        Library = "ExternalLib1",
        Include = "#include \"ExternalFunc1.h\"",
      );
  end ExternalFunc1;

  function ExternalFunc2 "Include header file for library implementation"
    input Real x;
    output Real y;
  external "C"
      annotation(
        Library = "ExternalLib2",
        Include = "#include \"ExternalFunc2.h\""
      );
  end ExternalFunc2;

end PackageA;
```

*PackageB/package.mo:*

```modelica
package PackageB

  function ExternalFunc1 "Include source file"
    input Real x;
    output Real y;
  external "C"
      annotation(
        Include = "#include \"ExternalFunc1.c\""
      );
  end ExternalFunc1;

end PackageB;
```

*Example.mo:*

```modelica
model Example
  Real x(start = 1.0);
  Real y(start = 2.0);
  Real z(start = 3.0);
equation
  der(x) = -PackageA.ExternalFunc1(x);
  der(y) = -PackageA.ExternalFunc2(y);
  der(z) = -PackageB.ExternalFunc1(z);
end Example;
```

Possible directory layout for `PackageA` and `PackageB`:

```text
├── PackageA
│   ├── Resources
│   │   ├── Include
│   │   │   ├── ExternalFunc1.h
│   │   │   └── ExternalFunc2.h
│   │   ├── Library
│   │   │   ├── linux64
│   │   │   │   ├── libExternalLib1.a
│   │   │   │   └── libExternalLib2.so
│   │   │   └── win64
│   │   │       ├── libExternalLib1.a
│   │   │       ├── libExternalLib2.dll
│   │   │       └── libExternalLib2.dll.a
│   │   └── Source
│   │       ├── Func1.c
│   │       ├── Func2.c
│   │       └── HelperFunc.c
│   └── package.mo
└── PackageB
    ├── Resources
    │   ├── Include
    │   │   └── ExternalFunc1.c
    │   └── Library
    │       └── linux64
    │           └── libExternalLib1.a
    └── package.mo
```

#### Base Modelica Output

The lowering tool collects all required binaries, pre-compiles any inline C sources (here `ExternalFunc3.c` becomes `libExternalFunc3`), and rewrites the annotations to use `base-modelica:` paths.

```modelica
//! base 0.1.0
package 'ExternalFunctions1.Example'
  function 'ExternalFunctions1.ExternalFunc1' "Include header file for library implementation"
    input Real 'x';
    output Real 'y';
  external "C" 'y' = ExternalFunc1_ext('x') annotation(
    Library = "ExternalLib1",
    LibraryDirectory = "base-modelica:ExternalFunctions1_Example/Library");
  end 'ExternalFunctions1.ExternalFunc1';

  function 'ExternalFunctions1.ExternalFunc2' "Include header file for library implementation"
    input Real 'x';
    output Real 'y';
  external "C" annotation(
    Library = "ExternalLib2",
    LibraryDirectory = "base-modelica:ExternalFunctions1_Example/Library");
  end 'ExternalFunctions1.ExternalFunc2';

  function 'ExternalFunctions2.ExternalFunc3' "Include source file"
    input Real 'x';
    output Real 'y';
  external "C" annotation(
    Library = "ExternalFunc3",
    LibraryDirectory = "base-modelica:ExternalFunctions1_Example/Library");
  end 'ExternalFunctions2.ExternalFunc3';

  model 'Example'
    Real 'x'(start = 1.0);
    Real 'y'(start = 2.0);
    Real 'z'(start = 3.0);
  equation
    der('x') = -'ExternalFunctions1.ExternalFunc1'('x');
    der('y') = -'ExternalFunctions1.ExternalFunc2'('y');
    der('z') = -'ExternalFunctions2.ExternalFunc3'('z');
  end 'Example';
end 'ExternalFunctions1.Example';
```

Files on disk next to `Example.bmo`:

```text
├── Example
│   ├── PackageA
│   │   └── Library
│   │       └── linux64
│   │           ├── libExternalLib1.a
│   │           └── libExternalLib2.so
│   └── PackageB
│       └── Library
│           └── linux64
│               └── libExternalLib1.a
└── Example.bmo
```

## External Objects

With a general framework for external functions established, it is also possible to discuss how to handle the special constructor and destructor functions from external objects.

> [!IMPORTANT]
> It isn't strictly needed to limit to the new `baseModelica` URI, but it removes all guess work for finding the correct library that needs to accompany a Base Modelica file when sharing it with others.

The author sees two plausible ways:

  1. Re-add `class`
  2. Prefix constructor and destructor functions with the external object class specifier.
    - Rules about return types of external functions need to be relaxed for the constructor.
    - Rules about input types for external functions need to be relaxed for the destructor.
    - Explicitly add constructor calls (easy)
    - Explicitly add destructor call (needs something new)

While the first option re-adds a single existing keyword from the Modelica language to Base Modelica, the second option would require broader changes.

### External Object Example

Here is a simple external object `Multiplier` from a package called `Multiplication` that needs to save some data during its lifetime.

```modelica
model ExternalObjectExample "Multiply a decaying signal by a constant factor stored in an external object"
  // The external object is created once with factor = 3.0.
  // It lives on the C heap for the duration of the simulation.
  Multiplication.Multiplier m = Multiplication.Multiplier(factor = 3.0);

  Real x(start = 1.0) "Decaying signal";
  Real y              "Scaled output: y = 3 * x";
equation
  der(x) = -x;
  y = Multiplication.multiply(m, x);
end ExternalObjectExample;
```

```C
/* Multiplier.c – external object that stores and applies a multiplication factor */
#include <stdlib.h>
#include "Multiplier.h"

typedef struct {
    double factor;
} Multiplier;

void *Multiplier_constructor(double factor) {
    Multiplier *m = (Multiplier *)malloc(sizeof(Multiplier));
    m->factor = factor;
    return (void *)m;
}

void Multiplier_destructor(void *obj) {
    free(obj);
}

double Multiplier_multiply(void *obj, double x) {
    Multiplier *m = (Multiplier *)obj;
    return m->factor * x;
}
```

### Option 1: Re-add Class `class`

The handling of the special `constructor` and `destructor` functions is one-to-one with Modelica.
No changes are needed.

An importing tool can deduce which objects need to be allocated and freed, and when to do so.

#### Re-adding `class` Example

OpenModelica already produces output very similar to the one listed here.
The only difference is that it is not using the new `base-modelica` URI from this proposal.

```modelica
loadFile("Modelica/Multiplication/package.mo"); getErrorString();
loadFile("Modelica/ExternalObjectExample.mo"); getErrorString();

setCommandLineOptions("--baseModelica"); getErrorString();

writeFile("BaseModelica/ExternalObjectExample.bmo", OpenModelica.Scripting.instantiateModel(ExternalObjectExample)); getErrorString();
```

```bash
cd examples/
omc lower.mos
```

The following is a slightly updated version with `base-modelica:` URIs and an explicitly named library directory.

```modelica
//! base 0.1.0
package 'ExternalObjectExample'
  function 'Multiplication.multiply' "Multiply x by the factor stored in the external object"
    input 'Multiplication.Multiplier' 'm';
    input Real 'x';
    output Real 'y';
  external "C" 'y' = Multiplier_multiply('m', 'x') annotation(
    Library = "Multiplication",
    LibraryDirectory = "base-modelica:ExternalObjectExample/Multiplication/Library");
  end 'Multiplication.multiply';

  class 'Multiplication.Multiplier'
    extends ExternalObject;

    function constructor "Allocate and initialise the multiplier"
      input Real 'factor';
      output 'Multiplication.Multiplier' 'obj';
    external "C" 'obj' = Multiplier_constructor('factor') annotation(
      Library = "Multiplication",
      LibraryDirectory = "base-modelica:ExternalObjectExample/Multiplication/Library");
    end constructor;

    function destructor "Free the multiplier"
      input 'Multiplication.Multiplier' 'obj';
    external "C" Multiplier_destructor('obj') annotation(
      Library = "Multiplication",
      LibraryDirectory = "base-modelica:ExternalObjectExample/Multiplication/Library");
    end destructor;
  end 'Multiplication.Multiplier';

  model 'ExternalObjectExample' "Multiply a decaying signal by a constant factor stored in an external object"
    'Multiplication.Multiplier' 'm' = 'Multiplication.Multiplier'(3.0);
    Real 'x'(start = 1.0) "Decaying signal";
    Real 'y' "Scaled output: y = 3 * x";
  equation
    der('x') = -'x';
    'y' = 'Multiplication.multiply'('m', 'x');
  end 'ExternalObjectExample';
end 'ExternalObjectExample';
```

### Option 2: `constructor` / `destructor` are special external functions

Use the class specifier of the external object `Multiplication.Multiplier` to prefix `constructor` / `destructor` functions.
Currently the output type of `'Multiplication.Multiplier.constructor'` and the input type of `'Multiplication.Multiplier.destructor'` need to be rejected since `void*` cannot be mapped to a Base Modelica type.
Relaxing that restriction without opening up all C types to be allowed in external functions could be difficult to achieve through grammar rules alone.

Should the importing tool know the new `'Multiplication.Multiplier.constructor'` and `'Multiplication.Multiplier.destructor'` are related to an external object because the name ends in `constructor` / `destructor`?
In that case, `constructor` and `destructor` need to be reserved keywords in Base Modelica.

Or where should a model explicitly call the constructor and destructor?
For the constructor this is easy, but what to do with the destructor?
This also does not feel very Modelica-like.
Memory management is done by the tool, not the modeler.

#### Explicit `constructor` / `destructor` calls Example

A possible different Base Modelica output with explicit `constructor` / `destructor` calls.
No tool prototype exists.
For demonstration purposes a new keyword `terminate` was added that becomes true after the simulation is done.

```modelica
//! base 0.1.0
package 'ExternalObjectExample'
  function 'Multiplication.multiply' "Multiply x by the factor stored in the external object"
    input 'Multiplication.Multiplier' 'm';
    input Real 'x';
    output Real 'y';
  external "C" 'y' = Multiplier_multiply('m', 'x') annotation(
    Library = "Multiplication",
    LibraryDirectory = "base-modelica:ExternalObjectExample/Multiplication/Library");
  end 'Multiplication.multiply';

  function 'Multiplication.Multiplier.constructor' "Allocate and initialise the multiplier"
    input Real 'factor';
    output 'Multiplication.Multiplier' 'obj';
  external "C" 'obj' = Multiplier_constructor('factor') annotation(
    Library = "Multiplication",
    LibraryDirectory = "base-modelica:ExternalObjectExample/Multiplication/Library");
  end 'Multiplication.Multiplier.constructor';

  function 'Multiplication.Multiplier.destructor' "Free the multiplier"
    input 'Multiplication.Multiplier' 'obj';
  external "C" Multiplier_destructor('obj') annotation(
    Library = "Multiplication",
    LibraryDirectory = "base-modelica:ExternalObjectExample/Multiplication/Library");
  end 'Multiplication.Multiplier.destructor';

  model 'ExternalObjectExample' "Multiply a decaying signal by a constant factor stored in an external object"
    'Multiplication.Multiplier' 'm' = 'Multiplication.Multiplier.constructor'(3.0);
    Real 'x'(start = 1.0) "Decaying signal";
    Real 'y' "Scaled output: y = 3 * x";
  equation
    der('x') = -'x';
    'y' = 'Multiplication.multiply'('m', 'x');

    when terminate then // <-- New construct `terminate`
      'Multiplication.Multiplier.destructor'('m');
    end when;
  end 'ExternalObjectExample';
end 'ExternalObjectExample';
```

[fmi-standard]: https://fmi-standard.org
[fmi-3.0.x]: https://fmi-standard.org/docs/3.0.2
[fmi-ls-ref]: https://github.com/modelica/fmi-ls-ref
[modelica-pull-3637]: https://github.com/modelica/ModelicaSpecification/pull/3637
[modelica-issue-2584]: https://github.com/modelica/ModelicaSpecification/issues/2584
[msl-12.9-ext-func-interface]: https://specification.modelica.org/master/functions.html#external-function-interface
[msl-12.9.1-arg-type-mapping]: https://specification.modelica.org/master/functions.html#argument-type-mapping
[msl-12.9.2-ret-type-mapping]: https://specification.modelica.org/master/functions.html#return-type-mapping
[msl-12.9.3-aliasing]: https://specification.modelica.org/master/functions.html#aliasing
[msl-12.9.4-annotations]: https://specification.modelica.org/master/functions.html#annotations-for-external-libraries-and-include-files
[msl-12.9.8-ext-obj]: https://specification.modelica.org/master/functions.html#external-objects
