#include <stdlib.h>
#include <stdio.h>
#include "binarytree.h"

typedef struct Node Node;

/*
 * creates a new binary search tree with the value provided being
 * the root node.
 */
Node* create(int value) {
    Node* ptr = (Node*) malloc(sizeof(Node));
    ptr->key = value;
    ptr->left = NULL;
    ptr->right= NULL;
    return ptr;
}

/*
 * inserts a (leaf) node to the supplied binary tree with the value
 * given. values added to the binary tree follow the rules for adding
 * onto a BST (Binary Search Tree).
 */
Node* insert(Node* root, int value) {
    if (root == NULL) {
        return create(value);
    }
    else {
        if (value < root->key) {
            root->left = (struct Node *) insert((Node *) root->left, value);
        }
        else if (value > root->key) {
            root->right = (struct Node *) insert((Node *) root->right, value);
        }
        return root;
    }
}

/*
 * deletes a node from the tree while preserving the properties
 */
Node* removeNode(Node* root, int key) {
    /* the base case. */
    if (root == NULL)
        return root;

    /* keep updating the root until we find the key we want deleted. */
    if (key < root->key) {
        root->left = removeNode(root->left, key);
    }
    else if (key > root->key) {
        root->right = removeNode(root->right, key);
    }
    else {
        /* case 1: the node only has 1 child*/
        if (root->left == NULL) {
            Node* temp = root->right;
            free(root);
            return temp;
        }
        else if (root->right == NULL) {
            Node* temp = root->left;
            free(root);
            return temp;
        }

        /* case 2: the node has two children, so we need a successor. */
        Node* temp = find_successor(root->right);
        root->key = temp->key;
        root->right = removeNode(root->right, temp->key);
    }

    return root;
}

Node *find_successor(Node* node) {
    Node* curr = node;

    /* find the leftmost leaf node. */
    while (curr != NULL && curr->left != NULL) {
        curr = (Node *) curr->left;
    }

    return curr;
}

/*
 * find a given value in the tree
 */
Node* find(Node* root, int value) {
    /* root is NULL or the key is at the root */
    if (root == NULL || root->key == value) {
        return root;
    }

    /* search the right subtree if the value is bigger than the current node */
    if (root->key < value) {
        return find((Node *) root->right, value);
    }
    else {
        return find((Node *) root->left, value);
    }
}

/*
 * walks the tree in-order which means that the left subtree will be visited
 * first, followed by the root, then finally by the right subtree.
 */
void inorder(Node* root) {
    if (root != NULL) {
        inorder((Node *) root->left);
        printf("%d ", root->key);
        inorder((Node *) root->right);
    }
}

/*
 * walks the tree in pre-order, so we first visit the root node, followed
 * by the left subtree, then finally by the right subtree.
 */
void preorder(Node* root) {
    if (root != NULL) {
        printf("%d ", root->key);
        preorder((Node *) root->left);
        preorder((Node *) root->right);
    }
}

/*
 * walks the tree in post-order which walks the left subtree first, then
 * the right subtree, and finally the root node.
 */
void postorder(Node* root) {
    if (root != NULL) {
        postorder((Node *) root->left);
        postorder((Node *) root->right);
        printf("%d ", root->key);
    }
}