if [ "$#" -ne 1 ] ; then
  echo "run.sh <llvm-dir>"
  exit 1
fi

echo "Bug link : https://bugs.llvm.org//show_bug.cgi?id=31652"
echo "Compiling.."
echo "Correct answer : f(10) = 20 / Buggy answer : f(10) = 1"
echo "------ run -------"
$1/bin/clang -S -emit-llvm -o test.O0.ll -O0 test.c
$1/bin/opt -S test.O0.ll -loop-rotate -licm -loop-unswitch -gvn | \
    $1/bin/opt -S -O2 | \
    $1/bin/llc -o test.S && $1/bin/clang test.S -o test && ./test
echo "------ end -------"
