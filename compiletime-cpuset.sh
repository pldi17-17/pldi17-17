#!/bin/bash
if [ "$#" -ne 2 ]; then
	echo "./compiletime-cpuset.sh <llvm-dir> <output-dir>"
	exit 1
fi


echo "pldi201717" | sudo -S PYTHONPATH="/mnt/freezedisk/cpuset:$PYTHONPATH" cset shield -c 1-3
sleep 0.02
echo "pldi201717" | sudo -S PYTHONPATH="/mnt/freezedisk/cpuset:$PYTHONPATH" cset shield \
  --user=pldi1717 --group=pldi1717 --exec \
  ./compiletime.sh $1 $2
echo "pldi201717" | sudo -S PYTHONPATH="/mnt/freezedisk/cpuset:$PYTHONPATH" cset shield --reset
sleep 0.02
