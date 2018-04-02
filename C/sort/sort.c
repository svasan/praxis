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

    if (input_file == NULL)
        generate_random_array(data->_array, count);
    else
        load_input_data(data->_array, count);
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
int shell_sort(sort_data_t *data);
int merge_sort(sort_data_t *data);

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
    case ShellSort:
        ret = shell_sort(data);
        break;
    case MergeSort:
        ret = merge_sort(data);
        break;
    case BubbleSort:
    case QuickSort:
    case HeapSort:
        fprintf(stderr,"Unimplemented sort algorithm: %s\n", sort_algo_name(data->_algo));
        exit(1);
    default:
        fprintf(stderr,"Invalid sort algorithm: %s (%d)\n",
               sort_algo_name(data->_algo), data->_algo);
        exit(1);
    }
    return ret;
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

int shell_sort(sort_data_t *data)
{
    unsigned gap = 1;
    while (gap < data->_count/3)
        gap = 3*gap + 1;

    unsigned *array = data->_array;
    stats_t *stats = data->_stats;
    while (gap > 0) {
        for(size_t i = gap; i < data->_count; i++)
            for(size_t j = i; j >= gap ; j=j-gap)
                if (less(array[j], array[j-gap], stats) == 0)
                    swap(array+j, array+j-gap, stats);
        gap = gap/3;
    }
    return 0;
}

// Expects the arrays to be merged to be contiguous, with array_1
// before array_2.
// The merged ouput is stored in the combined locations.
void __merge2(unsigned *start_1, unsigned *end_1, unsigned *start_2, unsigned *end_2, stats_t *stats)
{
    // Skip over parts of array_1 that are already in place ie smaller
    // than array_2.
    // The actual check is reverse - whether start_2 is lesser - so
    // that even equal items are left in place.
    while(less(*start_2, *start_1, stats) != 0 && start_1 < start_2)
        start_1++;

    if (start_1 == start_2)
        return;

    unsigned *start_merge = start_1, *end_merge = end_2;

    // Copy over remainder from array_1 into a tmp array and switch
    // the array_1 pointers to that.
    unsigned *buf = (unsigned *) malloc(sizeof(unsigned) * (start_2-start_1));
    if (!buf) {
        fprintf(stderr,"couldn't allocate temp buffer for merge");
        exit(1);
    }
    unsigned *tmp = buf;
    while (start_1 <= end_1)
        copy(start_1++, tmp++, stats);
    start_1 = buf;
    end_1 = tmp - 1;

    // Merge.
    while (start_merge <= end_merge) {
        if (start_1 > end_1) {
            /*
             * The first array is done. Everything now has to come
             * from the second array which is already at the end so
             * there is nothing more to do.
             */
            break;
        } else if (start_2 > end_2 || less(*start_1, *start_2, stats) == 0) {
            copy(start_1++, start_merge++, stats);
        } else {
            copy(start_2++, start_merge++, stats);
        }
    }
    return;
}

void __merge(unsigned *array, size_t start1, size_t start2, size_t end, stats_t *stats)
{
    /* The two arrays are adjacent: [start1..start2-1] [start2..end] */

    /*
     * Copy the first one into a temp location.
     * Skip any initial parts that are already in place.
     */
    unsigned tmp[start2-start1];

    size_t first_idx = start1;
    while (less(array[start2], array[first_idx], stats) != 0 && first_idx < start2)
        first_idx++;
    for(size_t i = first_idx; i < start2; i++)
        copy(array+i, tmp+i-start1, stats);

    size_t second_idx = start2;
    for(size_t i = first_idx; i <= end; i++) {
        if (first_idx >= start2) {
            /*
             * First array is done.
             * Whats left is from the second which is already at the end.
             */
            break;
        } else if (second_idx > end || less(tmp[first_idx-start1], array[second_idx], stats) == 0)  {
            copy(tmp+first_idx-start1, array+i, stats);
            first_idx++;
        } else {
            copy(array+second_idx, array+i, stats);
            second_idx++;
        }
    }
    return;
}

int __msort(unsigned *start, unsigned *end, stats_t *stats)
{
    /* printf("start=%zu end=%zu\n", start, end); */
    if (start == end)
        return 0;

    size_t mid = (end - start + 1)/2;

    unsigned *start_1 = start, *end_1 = start + mid - 1, *start_2 = start + mid, *end_2 = end;
    __msort(start_1, end_1, stats);
    __msort(start_2, end_2, stats);

    /* __merge2(array, start, mid, end, stats); */

    __merge2(start_1, end_1, start_2, end_2, stats);

    return 0;
}

int merge_sort(sort_data_t *data)
{
    return __msort(SORT_ARRAY_START_PTR(data),
                   SORT_ARRAY_END_PTR(data), data->_stats);
}
