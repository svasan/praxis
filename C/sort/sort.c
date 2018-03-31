#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include "sort.h"
#include "util.h"

char *sort_names[] = {
    "Selection",
    "Insertion",
    "Bubble",
    "Shell",
    "Merge",
    "Quick",
    "Heap",
    "Invalid"
};

// Skip Unknown
unsigned nalgos = sizeof(sort_names)/sizeof(char *);

sort_algo_t to_sort_algo(char *s)
{
    for(size_t i=0; i<nalgos; i++) {
        if (strncasecmp(sort_names[i], s, strlen(sort_names[i])) == 0) {
            return (sort_algo_t) i;
        }
    }

    return InvalidSort;
}

const char *sort_algo_name(sort_algo_t algo)
{
    if (algo < nalgos)
        return sort_names[algo];
    return sort_names[InvalidSort];
}

void generate_random_array(unsigned *array, size_t sz)
{
    for (size_t i = 0; i < sz; i++) {
        array[i] = random();
    }
}

sort_data_t *make_sort_data(sort_algo_t algo, size_t count)
{
    sort_data_t *data = malloc(sizeof(sort_data_t));
    if (data == NULL) {
        perror("Couldn't malloc sort_data_t");
        exit(1);
    }
    data->_algo = algo;
    data->_count = count;
    data->_array = malloc(sizeof(unsigned) * count);
    if (data->_array == NULL) {
        perror("Couldn't malloc array to sort");
        exit(1);
    }
    generate_random_array(data->_array, count);
    data->_stats = make_stats();
    return data;
}

int is_sorted(sort_data_t *data)
{
    unsigned *array = data->_array;
    for (size_t i = 1; i < (data->_count-1); i++) {
        if (array[i] < array[i-1])
            return -1;
    }
    return 0;
}

int selection_sort(sort_data_t *data);
int insertion_sort(sort_data_t *data);

int sort(sort_data_t *data)
{
    int ret = -1;
    switch (data->_algo) {
    case SelectionSort:
        ret = selection_sort(data);
        break;
    case InsertionSort:
        ret = insertion_sort(data);
        break;
    case BubbleSort:
    case ShellSort:
    case MergeSort:
    case QuickSort:
    case HeapSort:
        printf("Unimplemented sort algorithm: %s\n", sort_algo_name(data->_algo));
        exit(1);
    default:
        printf("Invalid sort algorithm: %s (%d)\n",
               sort_algo_name(data->_algo), data->_algo);
        exit(1);
    }
    return ret;
}

void print_result(sort_data_t *data)
{
    if (is_sorted(data) != 0) {
        printf("Array is not sorted\n");
        for (size_t i = 0; i < data->_count; i++) {
            printf("%llu\n", (unsigned long long) data->_array[i]);
        }
        exit(1);
    }

    print_stats(data->_stats);
}

int selection_sort(sort_data_t *data)
{
    unsigned *array = data->_array;
    stats_t *stats = data->_stats;
    size_t start = 0, end = data->_count -1;
    for (size_t i = start ; i <= end; i++) {
        size_t min = i;
        for (size_t j = i; j <= end; j++) {
            if (less(array[j], array[min], stats) == 0)
                min =j;
        }
        swap(array+i, array+min, stats);
    }

    return 0;
}

int insertion_sort(sort_data_t *data)
{
    unsigned *array = data->_array;
    stats_t *stats = data->_stats;
    size_t start = 0, end = data->_count-1;
    for(size_t i = 1; i <= end; i++) {
        for(size_t j = i; j > start; j--) {
            if (less(array[j], array[j-1], stats) == 0)
                swap(array+j, array+j-1, stats);
        }
    }
    return 0;
}
