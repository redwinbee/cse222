//
// Created by Edwin Bermudes on 5/4/23.
//

#include <stdlib.h>
#include <time.h>
#include <limits.h>
#include <printf.h>
#include "arrays.h"

void start() {
    srandom(time(0));
    unsigned char size = (unsigned char) random();

    printf("[arr]: generating arr of %d elements...\n", size);

    int* arr = createArray(size);
    for (int i = 0; i < size; i++) {
        printf("[%d]: current value = %d\n", i, arr[i]);
    }

    float avg = calculate_avg(arr, size);
    printf("[arr]: average of the arr is %f\n", avg);

    int max = find_max(arr, size);
    printf("[arr]: the maximum number in the arr is %d\n", max);

    int min = find_min(arr, size);
    printf("[arr]: the minimum number in the arr is %d\n", min);

    display(arr, size);
    int* sorted = bubble_sort(arr, size);
    display(sorted, size);
}

int* createArray(unsigned char size) {
    int *arr = malloc(size * sizeof(char));
    for (int i = 0; i < size; i++) {
        arr[i] = (unsigned char) random();
    }

    return arr;
}

float calculate_avg(int* array, int size) {
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += array[i];
    }

    return (float) sum / (float) size;
}

int find_max(int* array, int size) {
    int max = -1;
    for (int i = 0; i < size; i++) {
        max = (array[i] > max) ? array[i] : max;
    }

    return max;
}

int find_min(int* array, int size) {
    int min = UCHAR_MAX + 1;
    for (int i = 0; i < size; i++) {
        min = (array[i] < min) ? array[i] : min;
    }

    return min;
}

void display(int* array, int size) {
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