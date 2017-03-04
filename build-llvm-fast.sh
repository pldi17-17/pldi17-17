#!/bin/bash
if [ "$#" -ne 2 ] ; then
echo "build-llvm-fast.sh base <target dir>"
echo "build-llvm-fast.sh freeze <target dir>"
exit 1
fi

i=""
if [ "$1" = "base" ] ; then
i=$1
elif [ "$1" = "freeze" ] ; then
i=$1
else
echo "Unknown option : $1"
exit 2
fi

dir=`pwd`
rm -rf llvm-${i}/tools/clang
cp -r clang-${i} llvm-${i}/tools/clang

mkdir $2
cd $2
cmake ${dir}/llvm-${i} -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=1
cmake --build . -- -j4
