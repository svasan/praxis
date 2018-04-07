#!/usr/bin/env bash

usage() {
    echo "$0 [--compare] <size>"
    echo -e "\t --compare prints only the output statistic of the various algorithms"
}

if [ $# -eq 1 ]; then
    size=$1
elif [ $# -eq 2 ]; then
    compare="true"
    size=$2
else
    usage
    exit
fi

for sort in selection insertion bubble shell merge quick heap; do
    if ./sort -t $sort -c 1 2>/dev/null; then
	if ! ./sort -t $sort -c $size -i $size.input > $sort.$size.stdout 2>$sort.$size.stderr; then
	    echo "$sort sort failed with $size. See $sort.$size.stderr"
	    exit
	fi
	if ! head -$size $sort.$size.stdout | diff -uw $size.sorted - ; then
	    echo "$sort.$size.stdout does not match $sort.sorted"
	    exit
	fi
	if ! [ -z "$compare" ]; then
	    echo "$sort:"
	    tail -4 $sort.$size.stdout | sed -e 's/^/\t/'
	fi
	pass="$pass $sort"
	rm -f $sort.$size.{stdout,stderr}
    else
	skip="$skip $sort"
    fi
done
if ! [ -z "$pass" ]; then
    pass="$(echo $pass |sed -e 's/^ +//')"
    echo -n "$pass succeeded for $size. "
fi
if ! [ -z "$skip" ]; then
    skip="$(echo $skip |sed -e 's/^ +//')"
    echo "(Skipped $skip.)"
fi
