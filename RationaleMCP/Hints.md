Hints for generating a release.

Currently there are no automated procedures for generating the revision-history.

For the MCPs it is good to list additional pull requests considered, they can be found in GitHub's Pull Request list by searching for:
```
-base:master -base:maint/ is:merged: -label:MCP0031 -label:MCP0033 
```
Additionally it is good to list all pull request merged into the main branch after the latest release:
```
base:master merged:>=2020-12-31
```