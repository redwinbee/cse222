#include "myclass.h"

MyClass::MyClass() {
    x = 100;
    y = 200.0;
    ptr = new int;
    *ptr = 0;
}

MyClass::MyClass(int x, float y) {
    /*
     * we can access members in this class by using 'this' keyword, which is similar
     * to java, however, in C++ 'this' is a pointer.
     */
    this->x = x;
    this->y = y;
    ptr = new int;
    *ptr = 1234;
}

MyClass::~MyClass() {
    /*
     * we MUST delete any pointers associated with this object before we can delete the
     * object itself otherwise we will be left with memory we can't access, resulting in
     * a memory leak.
     */
    if (ptr != nullptr) {
        delete ptr;
    }
}

float MyClass::sum() {
    return x + y;
}
