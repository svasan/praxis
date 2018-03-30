#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sort.h"
#include "util.h"

/*
unsigned int DEFAULT_MAX_NUMBERS = 1024 * 1024;
*/

void usage_and_exit(char* name)
{
    printf("Usage: %s -c <count> \n", name);
    printf(" Where: \n" );
    printf("    -c <count> is the count of numbers to sort up to %u (RAND_MAX)\n", RAND_MAX);
    exit(1);
}

int main(int argc, char **argv)
{
    if (argc != 3)
        usage_and_exit(argv[0]);

    /*
    uint64_t count = DEFAULT_MAX_NUMBERS;
    const char *file = argv[1];
    */

    if (strcmp(argv[1],"-c") != 0) {
        usage_and_exit(argv[0]);
    }

    int64_t c = strtol(argv[2], NULL, 10);
    if (c <= 0) {
        printf("Invalid value %lli specified for -n\n", (long long int) c);
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
    */

    unsigned *arr = malloc(sizeof(unsigned) * count);
    /*
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

    generate_random_array(arr, count);
    stats_t *stats = make_stats();
    if (selection_sort(arr, count, stats) != 0) {
        printf("sort failed.\n");
        exit(1);
    }

    if (is_sorted(arr, count) != 0) {
        printf("Array is not sorted\n");
        for (size_t i = 0; i < count; i++) {
            printf("%llu\n", (unsigned long long) arr[i]);
        }
        exit(1);
    }

    print_stats(stats);

    return 0;

}
