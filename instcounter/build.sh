if [ "$#" -ne 1 ] ; then
echo "build.sh <llvm-dir>"
exit 1
fi

CXXFLAGS=`$1/bin/llvm-config --cxxflags`
LDFLAGS=`$1/bin/llvm-config --cxxflags --ldflags --libs core interpreter \
    analysis native bitwriter bitreader support transformutils --system-libs`
echo "CXXFLAGS:$CXXFLAGS"
echo "LDFLAGS:$LDFLAGS"
echo "========================="
g++ -std=c++11 $CXXFLAGS -c -o instcounter.o instcounter.cpp
echo "========================="
g++ -std=c++11 instcounter.o $LDFLAGS -o instcounter
