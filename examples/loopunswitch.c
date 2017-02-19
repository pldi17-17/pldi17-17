// Run : clang -O3 -S -emit-llvm -o loopunswitch.ll loopunswitch.c
#include<stdio.h>

int h();
int g1(int);
int g2(int);

void f(int n, int *a, int cond) {
  for (int i = 0; i < n; i++) {
    h(); 
    if (cond)
      g1(a[i]);
    else
      g2(a[i]);
  }
}
