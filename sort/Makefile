sort: *.c *.h
	gcc -g -o sort main.c sort.c util.c stats.c

clean:
	rm -f sort

test_10: sort sort_test.sh
	./sort_test.sh 10

test_100: sort sort_test.sh
	./sort_test.sh 100

test_1000: sort sort_test.sh
	./sort_test.sh 1000

test_10000: sort sort_test.sh
	./sort_test.sh 10000

test_1048576: sort sort_test.sh
	./sort_test.sh 1048576

test: test_10 test_100 test_1000 test_10000

compare_10: sort sort_test.sh
	./sort_test.sh --compare 10

compare_100: sort sort_test.sh
	./sort_test.sh --compare 100

compare_1000: sort sort_test.sh
	./sort_test.sh --compare 1000

compare_10000: sort sort_test.sh
	./sort_test.sh --compare 10000

compare_1048576: sort sort_test.sh
	./sort_test.sh --compare 1048576

compare: compare_10 compare_100 compare_1000 compare_10000
