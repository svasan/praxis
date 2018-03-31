#ifndef __UTIL_H__
#define __UTIL_H__

/* Returns 0 if a < b; -1 otherwise */
int less(unsigned a, unsigned b, stats_t *stats);

void swap(unsigned *a, unsigned *b, stats_t *stats);

#endif
