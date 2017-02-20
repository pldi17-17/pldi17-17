if [ "$#" -ne 1 ] ; then
  echo "run.sh <llvm-dir>"
  exit 1
fi

echo "Bug link : https://bugs.llvm.org/show_bug.cgi?id=27506"
echo "Compiling.."
$1/bin/clang -O0 a.c -S -emit-llvm -o a.ll
$1/bin/opt -S -mem2reg a.ll -o a.ll
$1/bin/opt -S -loop-unswitch a.ll -o a.ll
$1/bin/opt -S -gvn a.ll -o a.ll
$1/bin/opt -S -inline -inline-threshold=10000 a.ll -o a.ll
$1/bin/opt -S -sccp a.ll -o a.ll
$1/bin/clang -O0 a.ll b.c -o test
echo "Correct answer : (infinite loop) / Buggy answer : b = (some random number)"
echo "------ run -------"
timeout 1s ./test
EXITCODE=$?
if [[ "$EXITCODE" -eq 124 ]] ; then
echo "Timeout! This is a correct behavior"
fi
echo "------${i} end -------"
