#include <stdlib.h>
#include <stdio.h>
#include "linkedlist.h"

 /* creates a new node */
 Node* create(int value) {
    Node* ptr = (Node*) malloc(sizeof(Node));
    ptr->key = value;
    ptr->next = NULL;
    return ptr;
}

/* add a new node onto a linked list */
Node* add(Node* list, int value) {
    Node* node = create(value);

    // case 1: the list is empty, so we create a new linked list
    if (list == NULL) {
        return node;
    }

    // case 2: the value being added should be the new head of the list
    if (list->key >= value) {
        node->next = list;
        return node;
    }

    // case 3: we add the node to list where it needs to belong (sorted)
    Node* ptr = list;
    while (ptr->next != NULL) {
        Node* next = ptr->next;
        if (next->key > value) {
            // case 3a: the next one is greater than what we want to insert so we put in between
            node->next = next;
            ptr->next = node;
            return list;
        } else {
            ptr = next;
        }
    }

    // case 4: the node needs to be added to the end of the list
    ptr->next = node;
    return list;
 }

 Node* find(Node* list, int value) {

}

Node* delete(Node* list, int value) {
    Node* ptr = list;
    if (ptr == NULL) {
        return NULL;
    }

    Node* nextNode = ptr->next;
    if (ptr->key == value) {
        free(ptr);
        return nextNode;
    }

    while (nextNode != NULL) {
        if (nextNode->key == value) {
            ptr->next = nextNode->next;
            free(nextNode);
            return list;
        }
        else {
            ptr = nextNode;
            nextNode = nextNode->next;
        }
    }

    return list;
}

void display(Node* list) {
    printf("[");
    while (list->next != NULL) {
        printf("%d, ", list->key);
        list = list->next;
    }
    printf("%d]\n", list->key);
}

void deleteList(Node* list) {
    Node* temp = list;
    while (temp->next != NULL) {
        Node* ptr = temp->next;
        free(temp);
        temp = ptr;
    }
    free(temp);
}