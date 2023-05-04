#ifndef LECTURE03_LINKEDLIST_H
#define LECTURE03_LINKEDLIST_H

#include <stdbool.h>

typedef struct Node {
    int key;
    struct Node* next;
}Node;

Node* create(int value);
Node* add(Node* list, int value);
Node* delete(Node*, int value);
Node* find(Node* list, int value);
void display(Node*);
void deleteList(Node* list);


#endif //LECTURE03_LINKEDLIST_H
