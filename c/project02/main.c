#include <stdio.h>
#include <stdlib.h>
#include "binarytree.h"

int main() {
    struct Node* tree = (struct Node*) malloc(sizeof(struct Node));
    insert(tree, 9);
    insert(tree, 5);
    insert(tree, 7);
    insert(tree, 8);
    insert(tree, 9);
    insert(tree, 4);
    insert(tree, 3);
    insert(tree, 1);
    insert(tree, 2);
    insert(tree, 6);

    printf("inorder: ");
    inorder(tree);
    printf("\n");

    printf("preorder: ");
    preorder(tree);
    printf("\n");

    printf("postorder: ");
    postorder(tree);
    printf("\n");

    struct Node* val = find(tree, 3);
    printf("found value: %d", val->key);
    printf("\n");

    struct Node* del = removeNode(tree, 2);
    printf("deleted 2\n");
    printf("postorder: ");
    postorder(tree);
    printf("\n");

    return 0;
} 