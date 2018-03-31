sort: *.c *.h
	gcc -g -o sort main.c sort.c util.c stats.c

clean:
	rm -f sort

test_10_selection: sort
	./sort -t selection -c 10

test_100_selection: sort
	./sort -t selection -c 100

test_1k_selection: sort
	./sort -t selection -c 1000

test_selection: test_10_selection test_100_selection test_1k_selection

test_10_insertion: sort
	./sort -t insertion -c 10

test_100_insertion: sort
	./sort -t insertion -c 100

test_1k_insertion: sort
	./sort -t insertion -c 1000

test_insertion: test_10_insertion test_100_insertion test_1k_insertion

test_10: test_10_selection test_10_insertion

test_100: test_100_selection test_100_insertion

test_1k: test_1k_selection test_1k_insertion

test: test_10 test_100 test_1k
