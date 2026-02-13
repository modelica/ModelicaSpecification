# Modelica Change Proposal MCP-0039<br/>Licensing and encryption
Hubertus Tummescheit

**(In Development)**


## Summary

This specification describes a container for distributing Modelica
libraries and a protocol for how a Modelica tool should communicate with
an executable for licensing and decryption of the library. The following
scenarios are supported:

-   Both code encryption and licensing are supplied by library vendor.

-   Licensing is handled through a Modelica tool’s licensing mechanism,
    and code encryption is supplied by library vendor.

-   Library is open-source, no encryption or licensing is used.

The executable for licensing and decryption of the library is supplied
by the library vendor and will hereafter be referred to as the “LVE”
(Library Vendor Executable). The LVE should handle decryption and may
optionally handle licensing. The LVE is packaged together with the
library in a container. Several LVE may be included in the container for
different platforms.


## Revisions

| Version/Date                   | Changes/Comments                                                                             | Author                                     |
|--------------------------------|----------------------------------------------------------------------------------------------|--------------------------------------------|
| 0.1, 2015                      | Initial version                                                                              | Jesper Mattsson                            |
| 0.2, April 9<sup>th</sup> 2021 | Restructuring to separate out requirements and examples as appendices, minor wording updates | Hubertus Tummescheit                       |


## Contributor License Agreement

All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement".


## Rationale

The [rationale](rationale.md) presents the rationale with use cases.

The design, called _SEMLA_ is developed in a [separate document](SEMLA.md), for later incorporation as changesets for the Modelica Specification document.

A [manifest.xml example](examples/manifest.xml) is also provided.


## Backwards Compatibility

This MCP is orthogonal to any previous parts in the specification and
does not require any considerations w.r.t backwards compatibility. Note
that this proposal is orthogonal to and does not require any changes to
the protection annotation in the Modelica Language Specification.


## Tool Implementation

An open source reference implementation is available at
<https://github.com/modelon-community/SEMLA>. Is is licensed under the
BSD 3-clause license by Modelon and available for reuse or modification
by any interested party. This prototype has been in use since 2015 by
Modelon, as well as by ANSYS as a licensor of Modelon’s Modelica
compiler. Recently, OpenModelica has also implemented support that has
been tested by Modelon to also work well with Modelon’s commercial
libraries.

### Experience with Prototype

The protpype referenced above has been in use since 2015 and has
generally been positive and without problems. There are now two
independent implementations available, by Modelon as used in OCT, and by
the OpenModelica project.


## Required Patents

At best of your knowledge state any patents that would be required for
implementation of this proposal.


## References

- <https://www.openssl.org/>
- TLS 1.2 official specification: <https://tools.ietf.org/html/rfc5246>
- <https://github.com/modelon-community/SEMLA>
- <https://openmodelica.org/doc/OpenModelicaUsersGuide/latest/encryption.html>
- <https://www.modelon.com/leverage-standardized-encryption-and-licensing-for-modelica-libraries/>
- Additional material is available in the _MCP_00XX_SEMLA_v1_SpecChanges.docx_ belonging to the old MCP process.
