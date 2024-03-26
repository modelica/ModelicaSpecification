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


## Discussion of Weaknesses

There are several cryptographic keys involved. If someone were to
extract a key from an executable or alter the executable to change the
key, then that would have different consequences depending on what key
it is:

-   The private key of the tool

    -   Finding this key would allow decryption of all libraries that
        trust that key. It would be possible to replace the key, but
        that would require new releases (or at least new distributable)
        of all libraries that trust that tool.

    -   Altering this key would not be useful for an attacker.

-   The private key of the LVE

    -   It might be possible to eavesdrop on the communication between
        tool and LVE with this key. Requires additional study of chosen
        crypto scheme to determine. With private key of tool as well, it
        is definitely possible (but uninteresting if you have that key).

-   The session key

    -   Generated for each communication session, but could be extracted
        for a specific communication by debugging the tool or LVE.

    -   Finding this would allow eavesdropping on the communication.

    -   Altering this key is not possible.

-   List of public keys that the LVE trusts

    -   Finding this list would not be useful for an attacker.

    -   Altering this list would allow adding your own and thus allow
        decryption of the library.

-   The key/keys used by the LVE to decrypt the library

    -   Finding this key would allow decrypting the library.

    -   Altering this key would not be useful for an attacker.

Note that both the public/private key pair in the LVE and the key used
to decrypt the library could be newly generated for each build of the
library distributable.

All of these keys should be protected with some sort of obfuscation of
the object code to make them harder to extract. It would, however, be
impossible to completely protect against such attacks.

In conclusion, the most serious breach would be if an attacker obtained
the private key of the tool, allowing decryption of any library released
for that tool. The current situation is that the same vulnerability
necessarily exists in any tool that supports encrypted libraries.

Since Modelica tools need access to the Modelica source code by the
nature of the language specification, theses weaknesses have been
considered acceptable by all commercial parties that so far have made
use of this feature. The weaknesses are identical to those of
tool-specific encryption schemes.


## Requirements considered for the design of SEMLA

The following requirements for commercial libraries were considered in
the design of this proposal:

### Library Vendor

-   Library vendor needs to be able to define which libraries that
    should be available on which tools, i.e. explicit encoding of
    supported tools. *Yes, through list of trusted keys.*

<!-- -->

-   Library vendor needs to be able to enable/disable parts (features)
    in any given library based on standardized annotations. *Not
    hindered, standard license annotations are used.*

-   Library vendor needs to be able to specify visibility of components
    based on the standardized annotations. *Not hindered, standard
    license annotations are used.*

-   The solution should offer a means to check the license for the
    library as a whole without parsing the Modelica code. *Yes, optional
    alternate licensing mechanism can be used for tools that do not
    understand license annotations.*

-   Library vendor needs to be able to license/protect external
    libraries written in e.g. C and Fortran 77 independently of the
    licensing mechanism for the library. *Not affected by this
    specification, such checks can be added to the external libraries
    themselves.*

-   Library vendor needs to be able to make new releases of existing
    libraries and release new libraries without any action from the tool
    vendor. *Yes, when licensing is supplied by library vendor.*

-   Encryption mechanism shall be possible to use with or without the
    licensing mechanism of the protocol. *Yes.*

-   Encryption mechanism shall ensure protection of library vendor IP.
    (In this case, this is defined only as Modelica source code.) *In
    part. It is not possible to fulfill this completely, since
    everything necessary to decrypt the code must be available to the
    client computer. Protection is also limited by what the tool does or
    does not expose to the user. Extracting any IP that is not shown by
    the tool requires using decompilation and/or debugging tools to
    extract cryptographic keys from either the tool or the LVE (see
    Weaknesses below). This is similar to the current situation.*

-   The solution shall be not be limited to a specific licensing
    mechanism. *Yes, license mechanism is not specified. It is required
    that feature names are used, but this is also assumed by the
    description of licensing annotations in the Modelica language
    specification.*

-   The protocol shall offer means to with reasonable effort replace
    encryption keys, or equivalent, in cases of security breaches. *All
    involved keys belonging to library vendors can be switched for any
    library release. Changing the key pair used by the tool could be
    done by adding a second key pair during a transition period. Library
    vendors could then replace the compromised key with the new one in
    their list of trusted tools. A tool may have more than one key pair.
    For tools that have more than one key pair, the LVE needs to be
    restarted in between trying different key pairs.*

### Tool Vendor

-   A tool may store all files except Modelica source code on disc in
    unencrypted form, e.g., in order to support linking with library
    files during compilation. *Yes.*

-   The solution shall support standardized mechanisms for
    enabling/disabling parts of a library, by means of annotations
    defined in the Modelica specification. *Not hindered, standard
    license annotations are used.*

-   Well documented low-level API for licensing and encryption for easy
    integration in applications. *Documented above.*

-   Solution shall enable customizations and tailored functionality on
    top of the low-level API. *API is fairly generic and uses
    file-system model, this enables customizations through special files
    or folders.*

-   Error messages must be supported by the API. *Yes, error messages
    can be passed back to tool.*

-   Alternative, tool specific, licensing mechanisms shall not be
    prevented by the API. *Yes, license checking is controlled by tool.*

-   It shall be possible to store/ship several libraries/top-level
    packages in a single file. *Yes.*

### User

-   The API shall enable convenient to installation procedures for
    libraries. *Possible with tool support, library is distributed as a
    single file with a well-defined file extension.*

-   Error messages should enable users and support personnel to isolate
    errors related to licensing and encryption. *Yes, error messages can
    be passed back to tool.*
