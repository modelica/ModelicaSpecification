/* Multiplier.c – external object that stores and applies a multiplication factor */
#include <stdlib.h>
#include "Multiplier.h"

typedef struct {
    double factor;
} Multiplier;

void *Multiplier_constructor(double factor) {
    Multiplier *m = (Multiplier *)malloc(sizeof(Multiplier));
    m->factor = factor;
    return (void *)m;
}

void Multiplier_destructor(void *obj) {
    free(obj);
}

double Multiplier_multiply(void *obj, double x) {
    Multiplier *m = (Multiplier *)obj;
    return m->factor * x;
}
