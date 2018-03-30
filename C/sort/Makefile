sort: *.c *.h
	gcc -o sort main.c util.c stats.c selection_sort.c

clean:
	rm -f sort

test_10: sort
	./sort -c 10

test_100: sort
	./sort -c 100

test_1k: sort
	./sort -c 1000

test_all: test_10 test_100 test_1k
