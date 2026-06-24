package Multiplication

  class Multiplier "External object storing a multiplication factor"
    extends ExternalObject;

    function constructor "Allocate and initialise the multiplier"
      input Real factor;
      output Multiplier obj;
    external "C"
      obj = Multiplier_constructor(factor)
        annotation(
          Library = "Multiplication",
          Include = "#include \"Multiplier.h\"",
          LibraryDirectory = "modelica://Multiplication/Resources/Library");
    end constructor;

    function destructor "Free the multiplier"
      input Multiplier obj;
    external "C"
      Multiplier_destructor(obj)
        annotation(
          Library = "Multiplication",
          Include = "#include \"Multiplier.h\"",
          LibraryDirectory = "modelica://Multiplication/Resources/Library");
    end destructor;

  end Multiplier;

  function multiply "Multiply x by the factor stored in the external object"
    input Multiplier m;
    input Real x;
    output Real y;
  external "C"
    y = Multiplier_multiply(m, x)
      annotation(
        Library = "Multiplication",
        Include = "#include \"Multiplier.h\"",
        LibraryDirectory = "modelica://Multiplication/Resources/Library");
  end multiply;

end Multiplication;
