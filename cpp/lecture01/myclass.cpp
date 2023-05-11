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

MyClass::MyClass(const MyClass &clazz) {
    x = clazz.x;
    y = clazz.y;
    /* deep copy the contents from the pointer in clazz to a new pointer in the new class with the same values. */
    ptr = new int;
    *ptr = *(clazz.ptr);
}

MyClass MyClass::operator+(MyClass& clazz) {
    MyClass copy;
    copy.x = clazz.x + x;
    copy.y = clazz.y + y;
    *(copy.ptr) =  *(clazz.ptr) + *ptr;
    return copy;
}

MyClass &MyClass::operator=(const MyClass &clazz) {
    x = clazz.x;
    y = clazz.y;
    *ptr = *(clazz.ptr);
    return *this;
}

bool MyClass::operator==(const MyClass &clazz) {
    return (x == clazz.x && y == clazz.y);
}

// post-increment
MyClass* MyClass::operator++(int dummy) {
    MyClass ret;
    ret.x = x;
    ret.y = y;
    *(ret.ptr) = *ptr;

    x++;
    y++;
    *ptr = *ptr + 1;

    // avoid pointing to internal variables when returning
    MyClass *p = new MyClass();
    return p;
}

// pre-increment
MyClass& MyClass::operator++() {
    ++x;
    ++y;
    *ptr = *ptr + 1;
    return *this;
}

std::ostream& operator<<(std::ostream& out, MyClass& clazz) {
    out << "MyClass(" << clazz.x << ", " << clazz.y << ")" << std::endl;
    return out;
}
