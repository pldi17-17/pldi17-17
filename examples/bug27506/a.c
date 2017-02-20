#include <stdio.h>

extern void f(); // infinite loop
extern void g(); // skip

int foo(int argc, int undef) {
  int i, a, b, x, y;

  a = argc + 1;
  for (i = 0; i < 100; i++) {
    x = argc + i;
    if (x == argc) {
      y = argc + i;
      b = y + 1;
      if (b != 0) { f(); } else { g(); }
      printf("b = %d\n", b);
    }

    if (a == undef) {
      printf("0");
    }
  }
  printf("\n");

  return 0;
}

int main(int argc, char** argv) {
  int undef;
  foo(argc, undef);
  return 0;
}
