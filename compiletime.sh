#!/bin/bash
if [ "$#" -ne 2 ]; then
	echo "./compiletime.sh <llvm-dir> <output-dir>"
	exit 1
fi

dir=`pwd`
for i in bzip2 gzip gcc oggenc sqlite3 ; do
  echo "START $i"
  time $1/bin/clang -O3 -w -c -o $2/${i}.o $dir/singlefileprograms/$i/${i}.c
  echo "END $i"
done
