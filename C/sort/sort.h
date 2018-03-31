#ifndef __SORT_H__
#define __SORT_H__

#include "stats.h"

typedef enum {
    SelectionSort,
    InsertionSort,
    BubbleSort,
    ShellSort,
    MergeSort,
    QuickSort,
    HeapSort,
    InvalidSort,
} sort_algo_t;

sort_algo_t to_sort_algo(char *s);

typedef struct {
    sort_algo_t _algo;
    unsigned *_array;
    size_t _count;
    stats_t *_stats;
} sort_data_t;

sort_data_t *make_sort_data(sort_algo_t algo, size_t count);

int sort(sort_data_t *data);

int is_sorted(sort_data_t *data);

void print_result(sort_data_t *data);

#endif
