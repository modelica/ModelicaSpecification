// File ExternalFunc2.h
#ifdef __cplusplus
extern "C" {
#endif
#ifdef _MSC_VER
#ifdef EXTERNAL_FUNCTION_EXPORT
#  define EXTLIB2_EXPORT __declspec( dllexport )
#else
#  define EXTLIB2_EXPORT __declspec( dllimport )
#endif
#elif  __GNUC__ >= 4
  /* In gnuc, all symbols are by default exported. It is still often useful,
  to not export all symbols but only the needed ones */
#  define EXTLIB2_EXPORT __attribute__ ((visibility("default")))
#else
#  define EXTLIB2_EXPORT
#endif

EXTLIB2_EXPORT double ExternalFunc2(double x);

#ifdef __cplusplus
}
#endif
