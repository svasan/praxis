#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sort.h"

/*
unsigned int DEFAULT_MAX_NUMBERS = 1024 * 1024;
*/

void usage_and_exit(char* name)
{
    printf("Usage: %s -t <type> -c <count> \n", name);
    printf(" Where: \n" );
    printf("    <type> is one of: Selection, Insertion, Bubble, Shell, Merge, Quick, Heap\n");
    printf("    <count> is the count of numbers to sort up to %u (RAND_MAX)\n", RAND_MAX);
    exit(1);
}

int main(int argc, char **argv)
{
    if (argc != 5)
        usage_and_exit(argv[0]);

    /*
    uint64_t count = DEFAULT_MAX_NUMBERS;
    const char *file = argv[1];
    */

    if (strcmp(argv[1],"-t") != 0) {
        usage_and_exit(argv[0]);
    }

    sort_algo_t algo = to_sort_algo(argv[2]);
    if (algo == InvalidSort) {
        printf("Invalid -t option: %s\n", argv[2]);
        usage_and_exit(argv[0]);
    }


    if (strcmp(argv[3],"-c") != 0) {
        usage_and_exit(argv[0]);
    }

    int64_t c = strtol(argv[4], NULL, 10);
    if (c <= 0) {
        printf("Invalid value %lli specified for -c\n", (long long int) c);
        exit(1);
    }

    /* The range of random() is 0..RAND_MAX so more numbers will just be duplicates.*/
    if (c > RAND_MAX) {
        printf("Cannot generate more than %u numbers", RAND_MAX);
    }

    size_t count = c;

    /*
    file = argv[3];

    FILE *fp = fopen(file, "r");
    if (!fp) {
        char err[512];
        sprintf(err,"Open failed for file=%s", argv[1]);
        perror(err);
        exit(1);
    }

    char buf[256];
    uint64_t n = 0;
    for(; n < count && fgets(buf, 256, fp) != NULL; n++) {
        char *endptr = NULL;
        uint64_t val = strtol(buf, &endptr, 10);
        if (endptr == buf) {
            printf("Invalid number: %s\n", buf);
            exit(1);
        }
        arr[n] = val;
    }
    */

    sort_data_t *data = make_sort_data(algo, count);
    if (sort(data) != 0) {
        printf("sort failed.\n");
        exit(1);
    }

    print_result(data);

    return 0;

}
