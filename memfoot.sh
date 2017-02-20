#!/bin/bash
if [ "$#" -ne 2 ]; then
	echo "./memfoot.sh <llvm-dir> <output-dir>"
	exit 1
fi

LLVM=$1
OUTPUT=$2
for i in bzip2 gzip oggenc gcc sqlite3 ; do
  (./memfootprint.sh > ${OUTPUT}/${i}.memfoot.txt) & echo "MemRecord start"
  echo "START $i"
  ${LLVM}/bin/clang -O3 -w -c -o ${OUTPUT}/${i}.o ./singlefileprograms/${i}/${i}.c
  echo "END $i"
  PIDVAL=`pgrep memfootprint.sh`
  kill $PIDVAL
done

for i in `ls $2/*.memfoot.txt` ; do
  echo $i
  python parse-memfoot.py ${i} ${i}.csv
  python analyze-memfoot-csv.py ${i}.summary.csv ${i}.csv
done
