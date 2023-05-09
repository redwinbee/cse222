#pragma once

class MyClass {
private:
    int x;
    float y;
    int* ptr;

public:
    // constructors
    MyClass();
    MyClass(int x, float y);

    // destructors
    ~MyClass();
    float sum();
};