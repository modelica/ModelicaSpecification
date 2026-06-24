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
