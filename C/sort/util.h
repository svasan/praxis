#ifndef __UTIL_H__
#define __UTIL_H__

int generate_random_array(unsigned *arr, size_t sz);

/* Returns 0 if a < b; -1 otherwise */
int less(unsigned a, unsigned b, stats_t *stats);

void swap(unsigned *a, unsigned *b, stats_t *stats);

int is_sorted(unsigned *arr, size_t sz);

#endif
