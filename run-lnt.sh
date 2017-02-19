#!/bin/bash
if [ "$#" -ne 2 ] ; then
  echo "run-lnt.sh <sandbox dir> <llvm build dir>"
  exit 1
fi

dir=`pwd`
$1/bin/lnt runtest nt \
        --sandbox $1 \
        --cc  $2/bin/clang \
        --cxx $2/bin/clang++ \
        --test-suite ${dir}/llvm-test-suite/ \
        --benchmarking-only \
        ${branch} -j 1
