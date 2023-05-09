#include <iostream>
#include "myclass.h"

void swap_with_ptrs(int x, int y);
void swap(int& x, int& y);
void demoref(MyClass clazz);

int main() {
    std::cout << "Hello, C++!" << std::endl;

    /*
     * this actually initializes a new class of MyClass which is unlike in Java where if we wrote
     * this it would be null. This is similar to the line of Java code:
     *
     * MyClass clazz1 = new MyClazz();
     *
     * we have an object called clazz1 now.
     */
    MyClass clazz1;

    /*
     * this is just like C code where clazz2 is actually just a pointer, and we haven't initialized
     * a new class.
     */
    MyClass* clazz2 = nullptr;
    clazz2 = &clazz1; /* point clazz2 to clazz1. */

    /*
     * here we are explicitly calling the constructor and assigning this variable to a pointer of
     * out class. note: Clang-Tidy complains about something to do with auto here, but I don't know what
     * that means yet.
     *
     * BIG NOTE: you must delete the memory associated with clazz3 because of how we defined it as a new
     * object but stored a pointer. "delete" keyword requires the class to define a destructor.
     */
    MyClass* clazz3 = new MyClass();
    if (clazz3 != nullptr) {
        delete clazz3;
        clazz3 = nullptr;
    }

    // references in C++
    /*
     * we defined a variable 'x' and then we defined a reference 'y' AKA an "alias" of x which we can use
     * to modify the value stored in x through y. similar to how pointers work in C. We can only define 'y
     * to be the reference/alias to x ONE TIME, and we CANNOT tell y to be a reference to another variable
     * later on. we call this "binding" y to x.
     */
    int x = 10;
    int& y = x;
    y = 20;

    //std::cout << x << std::endl;


    int a = 10;
    int b = 20;
    swap(a, b);
    std::cout << a << std::endl;
    std::cout << b << std::endl;

    return 0;
}

void swap_with_ptrs(int* x, int* y) {
    int t = *x;
    *x = *y;
    *y = t;
}

void swap(int& x, int& y) {
    int t = x;
    x = y;
    y = t;
}

/*
 * defining a function this way will mean that C++ will generate an object called "clazz"
 * and all values from whatever class instance called on this function will be copied to this
 * class which is EXPENSIVE and SLOW, so there is a better way to do this below:
 */
void demoref(MyClass clazz) {
    return;
}

/*
 * this is much better since we have an alias here so we can work on the original class
 * that is passed to this function.
 */
void demoref(MyClass& clazz) {
    return;
}