#ifndef __STATS_H__
#define __STATS_H__

#include <time.h>
#include <stdint.h>

typedef struct {
    uint64_t _ncompares;
    uint64_t _nexchanges;
    clock_t _cpu_time;
} stats_t;

stats_t *make_stats();

void clear_stats(stats_t *stats);

void print_stats(stats_t *stats);

#endif
