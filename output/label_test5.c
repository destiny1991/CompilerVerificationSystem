#include <stdio.h>                                // 1
#include <stdlib.h>                               // 2

int add();                                        // 3

int sub();                                        // 4

int mul();                                        // 5

int main() {                                      // 6
    float a, b, c;                                // 6.1
    float d;                                      // 6.2

    scanf("%f %f %f %f", &a, &b, &c, &d);         // 6.3
    printf("%f %f %f %f", a, b, c, d);            // 6.4

     a = 1.2f;                                    // 6.5
    b = 1.3F;                                     // 6.6
    c = a * b + a;                                // 6.7

    a > 1;                                        // 6.8


    return 0;                                     // 6.9
}                                                 // 7

int add() {                                       // 8

}                                                 // 9

int sub() {                                       // 10

}                                                 // 11

int mul() {                                       // 12
	
}                                                 // 13
