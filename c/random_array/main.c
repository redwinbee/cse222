#pragma clang diagnostic push
#pragma ide diagnostic ignored "cert-msc50-cpp"
#pragma ide diagnostic ignored "cert-msc51-cpp"

#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define ARRAY_SIZE 20
#define UPPER_BOUND 100
#define LOWER_BOUND 5
#define RANGE (UPPER_BOUND - LOWER_BOUND)

void print_array(int arr[], int size);

int main() {
    // initialize the random number generator
    srand(time(NULL));

    // store random numbers in an array
    int random_numbers[ARRAY_SIZE] = {};
    for (int i = 0; i < ARRAY_SIZE; i++) {
        random_numbers[i] = (rand() % RANGE) + LOWER_BOUND;
    }

    print_array(random_numbers, ARRAY_SIZE);

    return 0;
}

void print_array(int arr[], int size) {
    printf("random number array: [");
    for (int i = 0; i < ARRAY_SIZE; i++) {
        printf("%s%d", (i == 0 ? "" : ", "), arr[i]);
    }
    printf("]\n");
}

#pragma clang diagnostic pop