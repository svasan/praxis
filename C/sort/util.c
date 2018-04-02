#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include "stats.h"

FILE *input_file = NULL, *output_file = NULL;

int less(unsigned a, unsigned b, stats_t *stats)
{
    stats->_ncompares++;
    if (a < b)
        return 0;
    return -1;
}

void swap(unsigned *a, unsigned *b, stats_t *stats)
{
    stats->_nexchanges++;
    unsigned tmp = *a;
    *a = *b;
    *b = tmp;
}


void copy(unsigned *from, unsigned *to, stats_t *stats)
{
    stats->_ncopies++;
    *to = *from;
}

void generate_random_array(unsigned *array, size_t sz)
{
    /*
     * The range of random() is 0..RAND_MAX so more numbers will just
     * be duplicates.  There may be duplicates even before though less
     * likely. In any case, this cannot be greater than UINT_MAX.
     * For now just use RAND_MAX as the limit.
     */
    if (sz > RAND_MAX) {
        fprintf(stderr,"Cannot generate more than %u numbers", RAND_MAX);
    }
    for (size_t i = 0; i < sz; i++) {
        array[i] = random();
    }
}

void load_input_data(unsigned *array, size_t sz)
{
    if (input_file == NULL) {
        fprintf(stderr, "No input file specified\n");
        exit(1);
    }

    char buf[256], ch;
    char *endptr;
    size_t n = 0, i = 0;
    while ((ch = fgetc(input_file)) != EOF) {
        if (ch  == '\n') {
            buf[i] = '\0';
            unsigned long val = strtoul(buf, &endptr, 10);
            if (val == 0 && buf == endptr) {
                fprintf(stderr, "Invalid number %s in input file", buf);
                exit(1);
            }
            array[n++] = val;
            if (n == sz)
                break;

            i = 0;
            continue;
        }
        buf[i++] = ch;
        if (i >= 255) {
            buf[255] = '\0';
            fprintf(stderr, "%s is too long", buf);
            exit(1);
        }
    }
    if (n < sz) {
        fprintf(stderr, "Expected %zu lines in input file but read only %zu\n", sz, n);
        exit(1);
    }
}

FILE *Fopen(char *file, char *mode)
{
    FILE *fp = fopen(file, mode);
    if (!fp) {
        char err[512];
        sprintf(err,"Open failed for file=%s mode=%s", file, mode);
        perror(err);
        exit(1);
    }
    return fp;
}

void print_array(FILE *fp, int idx, unsigned *start, unsigned *end)
{
    unsigned *p = start;
    while (p <= end) {
        if (idx)
            fprintf(fp,"\t[%zu]\t", p-start);
        fprintf(fp,"%10u\n", *p++);
    }
}
