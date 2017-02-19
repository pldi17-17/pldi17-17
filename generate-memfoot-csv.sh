#!/bin/bash
if [ "$#" -ne 1 ]; then
echo "./generate-memfoot-csv.sh <output-dir>"
exit 1
fi

for i in `ls $1/*.memfoot.txt` ; do
  echo $i
  python parse-memfoot.py ${i} ${i}.csv
  python analyze-memfoot-csv.py ${i}.summary.csv ${i}.csv
done
