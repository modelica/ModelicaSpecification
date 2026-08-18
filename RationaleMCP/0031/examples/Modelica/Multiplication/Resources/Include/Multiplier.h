/* Multiplier.h – opaque external object storing a multiplication factor */
#ifndef MULTIPLIER_H
#define MULTIPLIER_H

void  *Multiplier_constructor(double factor);
void   Multiplier_destructor(void *obj);
double Multiplier_multiply(void *obj, double x);

#endif /* MULTIPLIER_H */
