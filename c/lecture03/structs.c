#include <stdlib.h>
#include "structs.h"

void structs() {
    /* this is how we define structures. */
    struct MyStruct struct1;
    struct MyStruct* struct2;

    /* we can access members in a structure using the dot operator. */
    struct1.v1 = 1;
    struct1.v2 = 2;

    /* but if the structure is defined as a pointer we can use arrow notation
     * after we initialize the structure using malloc().
     */
    struct2 = malloc(sizeof(struct MyStruct));
    struct2->v1 = 3;
    struct2->v2 = 4;

    /* remember that we must free the memory when we no longer need the structure */
    free(struct2);
}