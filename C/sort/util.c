#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include "stats.h"

unsigned ncompares = 0;
unsigned nexchanges = 0;

int less(unsigned a, unsigned b, stats_t *stats)
{
    stats->_ncompares++;
    if (a < b)
        return 0;
    return -1;
}

void swap(unsigned *a, unsigned *b, stats_t *stats)
{
    stats->_nexchanges++;
    unsigned tmp = *a;
    *a = *b;
    *b = tmp;
}

int is_sorted(unsigned *arr, size_t sz)
{
    for (size_t i = 1; i < sz - 1; i++) {
        if (arr[i] < arr[i-1])
            return -1;
    }
    return 0;
}

int generate_random_array(unsigned *arr, size_t sz)
{
    for (size_t i = 0; i < sz; i++) {
        arr[i] = random();
    }
}
