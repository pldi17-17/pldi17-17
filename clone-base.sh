git clone https://github.com/llvm-mirror/llvm.git llvm-base
cd llvm-base
git reset --hard 00fd9cb07c2bd0b892fd51c1707bbcf0e03c4db8
cd ..
git clone https://github.com/llvm-mirror/clang.git clang-base
cd clang-base
git reset --hard 071180678d2add49ebfe64e5d6625fe01b235302
cd ..
