# The resolveURI operator

An operator with function syntax called `resolveURI` is introduced.
Compared to `loadResource`, it is more powerful, will have more clearly defined semantics, and is properly defined as Modelica lanugage feature instead of bypassing the Modelica Language Specification by means of `ModelicaServices`.

The result of `resolveURI(uri)` is a `String` giving the absolute filename of the external resource referenced by `uri`.
Unlike a normal function, it knows about its call site, so that it can apply normal lookup rules.

`resolveURI` accepts two kinds of URIs:
- _file:///…_ — only allowing absolute _file_ URIs
- _modelica:…?resource=…_ — a Modelica URI with a `resource` query (which excludes the legacy _host_ form)

The reason that relative file URIs are not supported by `resolveURI` is that the base URI would most naturally be the file in which the Modelica source code of the `resolveURI` expression is stored, but a Modelica tool is not required to store classes in a file system, so this also encourages the use of Modelica URIs to handle resources attached to a Modelica class.

While the initial design restricts the use Modelica URIs to those with a `resource` query, future extension to other queries will be possible whenever a query can be meaningfully resolved to a `String` result.

For a Modelica URI, `resolveURI` provides a context for lookup-based Modelica URIs, namely the class containing the `resolveURI` expression.
The following example illustrates how `resolveURI` gives context to a lookup-based URI:
```
package P
  model M
    model A
    end A;
    constant String uri;
    String filename = resolveURI(uri);
  end M;

  model A
  end A;

  M m(uri = "modelica:A?resource=table.mat");
end P;
```
Here, the lookup of `uri` doesn't take place where the string literal appears (namely `P`, which would have resulted in _…/P/A/resources.d/table.mat_).
Instead, the lookup happens in the context `P.M`, resulting in `m.filename` being _…/P/M/A/resources.d/table.mat_.

The example above may seem counter-intuitive, but the example is contrived and the potential confusion is typically avoided by applying `resolveURI` directly to a string literal; then the context of the string literal coincides with the context given by the `resolveURI` expression.

Note that a `resolveURI` expression is an expression resulting in an absolute filename, and shall not be used where a URI is expected (as in the `src` of an `img` tag in the `Documentation` annotation).

## Evaluation semantics

It would make sense to standardize on either of the following two variants:
- It only operates on constant strings.
  This way, application of lookup rules doesn't require a runtime representation of the class tree.
- It only evaluates at runtime, allowing a built simulation to be transferred from one tool installation to another.

A clear drawback of runtime evaluation is that it becomes impossible to make external resources part of a `constant` expression — the variability of a `resolveURI` expression would be no less than `parameter`.
