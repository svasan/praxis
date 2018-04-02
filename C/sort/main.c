#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sort.h"
#include "util.h"

void usage_and_exit(char* name)
{
    fprintf(stderr,"Usage: %s -t <type> -c <count> [-i <input file>] [-o <output file>]\n", name);
    fprintf(stderr," Where: \n" );
    fprintf(stderr,"    <type> is one of: Selection, Insertion, Bubble, Shell, Merge, Quick, and Heap.\n");
    fprintf(stderr,"    <count> is the count of numbers to sort.\n"
           "        These are generated using random() if -i is not specified.\n");
    fprintf(stderr,"    <input file> if specified is the file that contains the numbers to sort, one per line.\n"
           "        At most <count> number of lines are read from the file. Anything more is ignored.\n"
           "        %s aborts if the file has less than <count> lines\n", name);
    fprintf(stderr,"    <output file> if specified is the file to write the sorted numbers to with some stats at the end.\n"
           "        Defaults to stdout if it is not specified.\n");
    exit(1);
}

void print_result(sort_data_t *data)
{
    if (is_sorted(data) != 0) {
        fprintf(stderr,"Array is not sorted\n");
        print_array(stderr, 1, SORT_ARRAY_START_PTR(data), SORT_ARRAY_END_PTR(data));
        exit(1);
    }

    if (output_file) {
        print_array(output_file, 0, SORT_ARRAY_START_PTR(data), SORT_ARRAY_END_PTR(data));
        fprintf(output_file, "\n\n");
        print_stats(output_file, data->_stats);
    }
}

int main(int argc, char **argv)
{
    if (argc < 5)
        usage_and_exit(argv[0]);

    sort_algo_t algo = InvalidSort;
    size_t count = 0;
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i],"-t") == 0) {
            algo = to_sort_algo(argv[++i]);
            if (algo == InvalidSort) {
                fprintf(stderr,"Invalid -t option: %s\n", argv[i]);
                usage_and_exit(argv[0]);
            }
        } else if (strcmp(argv[i], "-c") == 0) {
            long c = strtol(argv[++i], NULL, 10);
            if (c <= 0) {
                fprintf(stderr,"Invalid value %lli specified for -c\n", (long long int) c);
                exit(1);
            }
            count = (size_t) c;
        } else if (strcmp(argv[i], "-i") == 0) {
            if (strcmp(argv[++i], "-") == 0)
                input_file = stdin;
            else
                input_file = Fopen(argv[i], "r");
        } else if (strcmp(argv[i], "-o") == 0) {
            output_file = Fopen(argv[++i], "w");
        } else {
            fprintf(stderr, "Unknown option: %s", argv[i]);
            usage_and_exit(argv[0]);
        }
    }

    // These options must be set.
    if (algo == InvalidSort || count == 0)
        usage_and_exit(argv[0]);

    /* If input is being read either from file or stdout, but no
       output file is specified, print to stdout */
    if (input_file != NULL && output_file == NULL)
        output_file = stdout;

    sort_data_t *data = make_sort_data(algo, count);
    if (sort(data) != 0) {
        fprintf(stderr,"sort failed.\n");
        exit(1);
    }

    print_result(data);

    return 0;

}
