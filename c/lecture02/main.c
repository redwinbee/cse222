#include <printf.h>
#include "main.h"

// this is another version of the main method
// argc = arg count
// argv = arg vector
// strings in C are defined as char arrays
int main(int argc, char* argv[]) {
    demo_pointer();

    // this is how we define a function pointer:
    // return_type (*func_ptr_name)(type_1, type_2, ..., type_n)
    int (*func_ptr)(int, int);

    // and here we save the "add" function address to this function pointer
    func_ptr = add;

    // and we can use it just like a regular function
    // but this seems redundant...
    int result = func_ptr(1, 1);
    printf("result of add: 1 + 1 = %d\n", result);


    // this is how we use the func_math function now
    int add_result = func_math(2, 2, add);
    printf("result of add using func_math: 2 + 2 = %d\n", add_result);

    // and if we want subtraction
    int sub_result = func_math(2, 2, sub);
    printf("result of sub using func_math: 2 - 2 = %d\n", sub_result);

    // -------------------------------------------------------------------------

    // memory management -- Java has a garbage collector (GC) that handles references
    // and cleans unused variables, but for C/C++ we must _manually_ manage pointers, so
    // if we have memory allocated and lose the pointer to that memory, that memory will not
    // be automatically recovered like in Java and will exist for the life of the program without
    // any means of recovering it. This is known as "memory leaks".

    // we can allocate memory using a built-in function called "malloc(bytes)" which returns a pointer
    // to the memory that was allocated. This is useful for creating dynamic arrays of unknown size at
    // compilation time

    // likewise since we need to free memory manually there is another function called "free()" that takes
    // a pointer to allocated memory and frees it for later use. if we don't do this, or if we forget, or
    // if there is a bug in our code, then that memory is lost, we get a memory leak.

    // since malloc() requires the number of bytes to reserve, there is another function called "sizeof(type)" to
    // get the size of whatever we want which we can then use to multiply by the number of elements that will be
    // stored

    // there is another memory allocation function called "calloc()" that stores _contiguous_ memory for us with
    // a small difference that we can define the number of elements as a separate argument. this function is hardly
    // used as malloc() does what we need anyway

    // "realloc()" serves as another function that can re-allocate memory for us if we need more space, but this
    // means that this function will copy _all_ data from the original block of memory to this new space. this function
    // handles freeing the memory of the pointer passed to it

    // -------------------------------------------------------------------------

    // structs -- C is not an OOP language, but we can use structs to create some kind of order or relationship
    // between data types, however, there are no associated functions to structs and everything is considered to be
    // "public" in a sense that there are _no_ types that we can define in a struct that are _only_ available to itself

    return 0;
}

// now with this we can use one function to perform operations on two numbers
// and which operation to perform using a function pointer to make this clearer
int func_math(int x, int y, int(*func_p)(int, int)) {
    return func_p(x, y);
}

int add(int x, int y) {
    return x + y;
}

int sub(int x, int y) {
    return x - y;
}

int demo_pointer() {
    // declaring pointers -- can be of any type or even point to a function
    // pointers store the memory address of variables
    // data_type* var_name;
    int* p1;
    char* p2;

    // we can save the address of the variable x to p1 using the operator '&'
    // in general, we can get the address of any variable/function using the '&' function
    int x = 100;
    p1 = &x;

    // this is the preferred method of declaring pointers; all in one line
    int* p3 = &x;

    // we can also define pointers of pointers
    int** p4 = &p3;

    // we can change values using pointers
    printf("x=%d, x=%d\n", x, *p1);
    *p1 = 120;
    printf("x=%d, x=%d\n", x, *p1);

    // using pointers to do what we couldn't do in java; swap numbers
    int a = 100;
    int b = 200;
    printf("a=%d, b=%d\n", a, b);
    swap(&a, &b);
    printf("a=%d, b=%d\n", a, b);

    // -------------------------------------------------------------------------

    // defining arrays -- here we define an array of length 5 and call it "arr"
    // which is created and initialized with default values
    int arr1[5];

    // another method for defining arrays but with values
    int arr2[5] = {1, 2, 3, 4, 5};

    // final method to define an array without specifying the size
    int arr3[] = {1, 2, 3, 4, 5, 6};

    // we can use pointers on arrays and both of these are valid and the same but
    // the first one is simpler
    int* arr2_ptr1 = arr2;
    int* arr2_ptr2 = &(arr2[0]);

    // we can print the first element this way
    printf("value at arr1[0] = %d\n", *arr2_ptr1);

    // and if we want to print the 3rd element for example
    printf("value at arr1[2] = %d\n", *(arr2_ptr1 + 2));

    // -------------------------------------------------------------------------

    // using pointers to visit and print every value in an array
    // the addition being done is based on the data type stored, so for integer type this
    // value "ptr" is being incremented by 4 bytes
    printf("(method 1)\n");
    int my_array[] = {1, 2, 3, 4, 5};
    int* ptr = my_array;
    for (int i = 0; i < 5; i++, ptr++) {
        printf("[%d]: value = %d\n", i, *(ptr));
    }

    // or using i directly to increment pointer
    printf("(method 2)\n");
    ptr = my_array;
    for (int i = 0; i < 5; i++) {
        printf("[%d]: value = %d\n", i, *(ptr + i));
    }
}

void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}