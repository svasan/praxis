#ifndef __UTIL_H__
#define __UTIL_H__

extern FILE *input_file, *output_file;

/* Returns 0 if a < b; -1 otherwise */
int less(unsigned a, unsigned b, stats_t *stats);

void swap(unsigned *a, unsigned *b, stats_t *stats);

void copy(unsigned *from, unsigned *to, stats_t *stats);

void generate_random_array(unsigned *array, size_t sz);

void load_input_data(unsigned *array, size_t sz);

FILE *Fopen(char *file, char *mode);

void print_array(FILE *fp, int idx, unsigned *start, unsigned *end);

#endif
