model Example
  Real x(start = 1.0);
  Real y(start = 2.0);
  Real z(start = 3.0);
equation
  der(x) = -PackageA.ExternalFunc1(x);
  der(y) = -PackageA.ExternalFunc2(y);
  der(z) = -PackageB.ExternalFunc1(z);
end Example;
