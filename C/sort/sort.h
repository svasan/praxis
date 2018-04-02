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

#define SORT_ARRAY_START_PTR(data) ((data)->_array)
#define SORT_ARRAY_END_PTR(data) ((data)->_array + (data)->_count -1)

sort_data_t *make_sort_data(sort_algo_t algo, size_t count);

int sort(sort_data_t *data);

int is_sorted(sort_data_t *data);

#endif
