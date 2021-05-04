# Rationale

With a broad ecosystem of Modelica tool and library vendors now active,
a simplified sharing of libraries between different tools, as well as of
private models and libraries between collaborators in Model Based Design
will increase the attractiveness of Modelica as a preferred solution for
model based systems engineering and design. A format as proposed would
allow to independent developers to develop libraries in a single format
that can be loaded and processed by all compliant Modelica tools, as
well as monetization of such libraries.

The proposal describes a container format for Modelica Libraries that
can be both encrypted and unencrypted. It also describes an executable
called the “LVE” that does the decryption of a library as well as the
(optional) licensing. The proposal also describes a communication
protocol between the LVE and a Modelica tool that would like to read an
encrypted and (optionally) licensed library. This setup allows to use
both a licensing mechanism provided by the library vendor (through the
LVE), and a mechanism that is specific and proprietary to a Modelica
tool, and only the encryption is handled through the LVE. Note that
licensing through the Library vendor is a critical component in allowing
independent Library developers to enter the market for Modelica
Libraries.

Note that the proposal tries to reuse known and well-tested open-source
technologies – like openssl – as much as possible to reduce risk and
implementation.

## Use cases

-   Use case 1: An independent Library Vendor would like to provide a
    single, unified library distribution to several Modelica tools. A
    single container file can be distributed to end users of different
    tools, and the packaging and distribution effort for library
    developers is reduced.

-   Use case 2: A supplier and an OEM want to share models that contain
    sensitive IP. Licensing is not necessary, but it is possible to
    share encrypted models between them. Note that SEMLA only takes care
    of the storage format of the models on disk, the protection inside
    the tool continues to be the responsibility of the tool that loads
    the model.

-   Use case 3: A Modelica end user company wants to use 1 commercial
    Modelica Library with different Modelica tools. In the current
    setup, the end user might have to pay each tool vendor separately
    for the same library. SEMLA and licensing by the Library vendor
    allows end users to use a single license for a library in multiple
    tools.
