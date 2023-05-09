#include "main.h"

#include <stdio.h>

int main(int argc, char* argv[]) {
  int x = 0;
  scanf("%d", &x);

  int (*func_ptr)(int, int);
  func_ptr = add;
  int = func_ptr(x, y);
  return 0;
}

int process(int x, int y, int (*func_ptr)(int, int)) { return func_ptr(x, y); }
int add(int x, int y) { return x + y; }
int sub(int x, int y) { return x - y; }