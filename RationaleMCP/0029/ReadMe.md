# Modelica Change Proposal MCP-0029<br/>License Export
Thomas Beutlich

**(In Development)**

## Summary
The primary goal is to support Modelica simulation tools in providing the correct licenses for exported models that are meant for distribution, e.g. FMUs.
By introduction of additional annotations the exporting Modelica tool can utilize these license information (no matter if open-source license or proprietary license) according to the exported target.
This applies both to the code generated from the utilized top-level Modelica classes as well as for the external function interface (Include or static/shared Library) of Modelica.
This shifts the responsibility of providing the necessary license information from the tool vendors to the Modelica library developers.

## Revisions
| Date | Description |
| --- | --- |
| 2017-12-07 | Thomas Beutlich. Based on input from Christian Bertsch at [FMI#417](https://github.com/modelica/fmi-standard/issues/417) |
| 2023-07-07 | Hans Olsson. Added prototype implementation |

## Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement".

## Rationale
Translated and exported Modelica models, which are meant for distribution, need to provide the necessary licenses, i.e., the licenses of third-party software used in external functions and libraries and the license of the top-level Modelica package itself.

Currently, the license information is neither considered at all (even if available as documentation or resource) for exported models or based on some analysis of tool vendors to create at least some kind of exported license information.
This proposal improves the situation both for tool vendors as well as library developers to create legally correct exported models.
A library developer needs to provide the relevant license information as external resource, which on the other hand can be considered by a Modelica tool during the export process.

Use-cases:
1. Export a Modelica model with Modelica.Blocks.Continuous.PID as FMU for ME and distribute this FMU to external customers or partners.
Along with the FMU the distributor needs to provide the information of utilized software components, e.g., the MSL, which as of v4.0.0 is licensed under the 3-Clause BSD license.
1. Export a Modelica model with Modelica.Blocks.Sources.CombiTable1D as S-Function and distribute this S-Function to external customers or partners.
Along with the S-Function the distributor needs to provide the information of utilized third-party software of the ModelicaStandardTables, zlib, uthash etc.
1. Export a Modelica model with Modelica.Blocks.Continuous.PID as FMU for CS and distribute this FMU to external customers or partners.
Along with the FMU the distributor needs to provide the information of utilized software components, e.g., the utilized solver.
The license conditions of the solver component need to be respected, e.g., in case of the SUNDIALS CVode solver the relevant license information should be made obvious for the FMU receiver by means of an appropriate license file/text.

Remark: Compared to the first two aspects, the third aspect solely is a tool issue, but stated here for completeness.

## Backwards Compatibility

This change does not introduce any backwards incompatibilities.

## Tool Implementation

### Experience with Prototype

On the library side, the necessary changes have been applied to library _ExternData_.
The following commits at the Git repository at https://github.com/modelica-3rdparty/ExternData demonstrate the necessary steps to update a Modelica libarry.

1. https://github.com/modelica-3rdparty/ExternData/commit/7522046dce6d20fe01a85a559b02fd9d8878bdd2
   - All license files were added as text files to a new directory ExternData/Resources/Licenses.
     The file format is not restricted to Text with a special encoding, but any file format (e.g., Mark-Down, PDF, HTML) basically can be supported.
     The license file LICENSE_ExternData.txt is the corresponding license of the copyright holder of the Modelica package, all other license files reflect third-party software components.
   - It is recommended to use ModelicaPackage/Resource/Licenses as the directory for the license files.
1. https://github.com/modelica-3rdparty/ExternData/commit/f38372d825b20eac4de01ce01b95560522b43ad2
   - The license file LICENSE_ExternData.txt of the Modelica package is referenced by the Modelica top-level class as new annotation License="modelica://ExternData/Resources/Licenses/LICENSE_ExternData.txt".
     To introduce this new annotation on existing Modelica packages in a Modelica-compliant and vendorneutral way, the `__ModelicaAssociation` prefix was added (similar as `__ModelicaAssociation_Impure` in MSL v3.2.2).
     This means, that library developers can adopt early to this proposal, for example a new MSL v3.2.3 can already introduce this new annotation and is not needed to be based on a new release of the Modelica language specification.
1. https://github.com/modelica-3rdparty/ExternData/commit/d6dec789aec1c1333386161147c91cdd49b484d0
   - All third-party licenses are listed as new License annotation to the external functions.
     There is some redundancy here in specifying the license directory many times in the Modelica URIs, but this is not a serious issue.
     Again, the `__ModelicaAssociation` prefix was added for Modelica-compliant tool-neutrality

Currently, a simple prototype is implemented in Dymola, supporting top-level and function annotation (both variants) and including them in the documentation folder in the FMI.
As previously estimated implementation effort for exporting Modelica models with exported licenses is rather low.
A tool needs to collect the license information of all utilized top-level Modelica packages and all utilized external functions and copy these files to the specified export directory depending on the export target system.

## Required Patents

No patent known that would be required for implementation of this proposal.

## References

FMUs must contain all relevant license information. https://github.com/modelica/fmi-standard/issues/417

Vendor Neutral Modelica Annotation Prototypes in MSL. https://github.com/modelica/ModelicaStandardLibrary/issues/849

Analysis of third-party licenses of the MSL C-Sources. https://github.com/modelica/ModelicaStandardLibrary/issues/2253

Issue with discussions prior to creation of MCP branch. https://github.com/modelica/ModelicaSpecification/issues/2217
