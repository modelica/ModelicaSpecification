# The resolveURI operator

An operator with function syntax called `resolveURI` is introduced.  Unlike a normal function, it knows about its call site, so that it can apply normal lookup rules.  It would make sense to standardize on either of the following two variants:
- It only operates on constant strings. This way, application of lookup rules doesn't require a runtime representation of the class tree.
- It only evaluates at runtime, allowing a built simulation to be transferred from one tool installation to another.
