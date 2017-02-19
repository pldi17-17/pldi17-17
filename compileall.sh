#!/bin/bash
if [ "$#" -ne 2 ]; then
	echo "./compile.sh <llvm-dir> <output-dir>"
	exit 1
fi

dir=`pwd`
for j in bzip2 gzip gcc oggenc sqlite3 ; do
  $1/bin/clang -O3 -w -c -o $2/${j}.o $dir/singlefileprograms/$j/${j}.c
  $1/bin/clang -O3 -w -S -emit-llvm -o $2/${j}.ll $dir/singlefileprograms/$j/${j}.c
  $1/bin/llvm-as -o $2/${j}.bc $2/${j}.ll
done
