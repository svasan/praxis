#include <stdio.h>
#include <stdlib.h>
#include "stats.h"

stats_t *make_stats()
{
    stats_t *stats = malloc(sizeof(stats_t));
    if (stats == NULL) {
        perror("Couldn't malloc for stats");
        exit(1);
    }
    clear_stats(stats);
    return stats;
}

void clear_stats(stats_t *stats)
{
    stats->_ncompares = stats->_nexchanges = stats->_ncopies = stats->_cpu_time = 0;
}

void print_stats(stats_t *stats)
{
    printf("Comparisons: %llu, Copies: %llu, Exchanges: %llu, Time: %Lg\n",
           (unsigned long long) stats->_ncompares,
           (unsigned long long) stats->_ncopies,
           (unsigned long long) stats->_nexchanges,
           (long double) (stats->_cpu_time / CLOCKS_PER_SEC));
}
