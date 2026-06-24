// File Func2.c - C source for ExternalLib2
// EXTERNAL_FUNCTION_EXPORT is set by the build system (CMake -DEXTERNAL_FUNCTION_EXPORT)
#include "../Include/ExternalFunc2.h"

// helperFunc is defined in HelperFunc.c, also part of ExternalLib2
extern double helperFunc(double x);

double ExternalFunc2(double x) {
    return helperFunc(x);
}
