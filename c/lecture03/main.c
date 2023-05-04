#include <stdlib.h>
#include <stdio.h>
#include "main.h"
#include "structs.h"
#include "linkedlist.h"

int main() {
    float x = 100;
    printf("x = %f\n", x);
    float* float_ptr = &x;
    float* null_ptr = NULL;
    *float_ptr = 99;
    printf("float_ptr = %f\n", *(float_ptr));
    printf("x = %f\n", x);

    // -----------------------------------------

    int array[] = {1, 3, 5, 7};
    int size = 4;
    int* arr_ptr = array;
    display_array(array, size);
    for (int i = 0; i < size; i++) {
        arr_ptr[i] += 1;
    }
    display_array(array, size);

    // -----------------------------------------

    structs();

    Node* list = NULL;
    list = add(list ,6);
    list = add(list ,7);
    list = add(list ,4);
    list = add(list ,3);
    list = add(list ,9);

    display(list);
    delete(list, 6);
    display(list);
    deleteList(list);

    return 0;
}

void display_array(int array[], int size) {
    printf("[");
    for (int i = 0; i < size; i++) {
        if (i != size - 1) {
            printf("%d, ", array[i]);
        } else {
            printf("%d", array[i]);
        }
    }
    printf("]\n");
}
