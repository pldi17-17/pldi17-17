static volatile int always_false = 0;

void maybe_init(int *p) {}

int f(int limit0) {
  int maybe_undef_loc;
  maybe_init(&maybe_undef_loc);

  int limit = limit0;
  int total = 0;
  for (int i = 0; i < limit; i++) {
    total++;
    if (always_false) {
      if (maybe_undef_loc != (limit0 + 10)) {
        total++;
      }
    }
    limit = limit0 + 10;
  }
  return total;
}

int printf(const char *, ...);

int main(int argc, char **argv) {
  printf("f(10) = %d\n", f(10));
  return 0;
}
