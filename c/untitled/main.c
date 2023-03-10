#include <stdio.h>
#include <sodium.h>

int main() {
    // Initialize the libsodium library
    if (sodium_init() < 0) {
        printf("Failed to initialize libsodium\n");
        return 1;
    }

    // Generate a buffer of random bytes
    unsigned char buf[4];
    randombytes_buf(buf, sizeof(buf));

    // Use the first 4 bytes of the buffer as a random integer
    int num = *((int*)buf) % 100;

    printf("The random number is: %d\n", num);
    return 0;
}