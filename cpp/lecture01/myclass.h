#pragma once

#include <ostream>

class MyClass {
private:
    int x;
    float y;
    int *ptr;

public:
    // constructors
    MyClass();

    MyClass(int x, float y);

    // special name: "Copy Constructor" acts similar to clone() method in Java
    MyClass(const MyClass &clazz);

    // destructors
    ~MyClass();

    // overloading special functions
    MyClass operator+(MyClass& clazz);

    MyClass& operator=(const MyClass& clazz);

    bool operator==(const MyClass& clazz);

    MyClass* operator++(int dummy); // x++ the post-increment operator

    MyClass& operator++(); // ++x the pre-increment operator

    float sum();

    friend std::ostream& operator<<(std::ostream& out, MyClass& clazz);

private:

};