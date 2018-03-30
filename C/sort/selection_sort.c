#include <stdint.h>
#include <stdlib.h>
#include "sort.h"
#include "util.h"

int selection_sort(unsigned *arr, size_t sz, stats_t *stats) {
    size_t start = 0, end = sz -1;
    for (size_t i = start ; i <= end; i++) {
        size_t min = i;
        for (int j = i; j <= end; j++) {
            if (less(arr[j], arr[min], stats) == 0)
                min =j;
        }
        swap(arr+i, arr+min, stats);
    }

    return 0;
}
