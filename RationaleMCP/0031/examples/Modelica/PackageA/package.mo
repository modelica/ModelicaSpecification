package PackageA

  function ExternalFunc1 "Include header file for library implementation"
    input Real x;
    output Real y;
  external "C"
    y = ExternalFunc1_ext(x)
      annotation(
        Library = "ExternalLib1",
        Include = "#include \"ExternalFunc1.h\"",
        // SourceDirectory is the default and thus redundant:
        SourceDirectory = "modelica://PackageA/Resources/Source"
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
