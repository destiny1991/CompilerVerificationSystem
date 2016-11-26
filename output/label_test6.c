#include <stdio.h>                                // 1

int add(int x, int y);                            // 2
int sub(int x, int y, int d);                     // 3
int inc(int x);                                   // 4

int main() {                                      // 5
    int a, b, c;                                  // 5.1
    int d;                                        // 5.2
    int e;                                        // 5.3

    a = 1;                                        // 5.4
    b = 2;                                        // 5.5
    c = add(a, 3);                                // 5.6
    d = sub(a, c, b);                             // 5.7
    e = inc(4);                                   // 5.8

    printf("The add result is : %d\n", c);        // 5.9
    printf("The sub result is : %d\n", d);        // 5.10
    return 0;                                     // 5.11
}                                                 // 6

int add(int x, int y) {                           // 7
    int z;                                        // 7.1
    z = x + y;                                    // 7.2
    printf("add function %d\n", z);               // 7.3
    printf("add x %d, y %d\n", x, y);             // 7.4
    printf("addd addd\n");                        // 7.5
    return z;                                     // 7.6
}                                                 // 8

int sub(int x, int y, int d) {                    // 9
    int z;                                        // 9.1
    z = x - y - d;                                // 9.2
    printf("sub function %d\n", z);               // 9.3
    return z;                                     // 9.4
}                                                 // 10

int inc(int x) {                                  // 11
    int z;                                        // 11.1
    z = x + 1;                                    // 11.2
    return z;                                     // 11.3
}                                                 // 12
