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
