model ExternalObjectExample "Multiply a decaying signal by a constant factor stored in an external object"
  // The external object is created once with factor = 3.0.
  // It lives on the C heap for the duration of the simulation.
  Multiplication.Multiplier m = Multiplication.Multiplier(factor = 3.0);

  Real x(start = 1.0) "Decaying signal";
  Real y             "Scaled output: y = 3 * x";
equation
  der(x) = -x;
  y = Multiplication.multiply(m, x);
end ExternalObjectExample;
