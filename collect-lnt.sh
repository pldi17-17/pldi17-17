if [ "$#" -ne 2 ]; then
echo "collect-lnt.sh <inputdir(mysandbox)> <outputdir>"
exit 1
fi

python parse-lnt.py $1 $2/cc.csv $2/rt.csv
python sort-lnt.py $2/cc.csv $2/cc.sorted.1per.csv
python sort-lnt.py $2/rt.csv $2/rt.sorted.1per.csv
