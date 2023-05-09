struct Node {
    int key;
    struct Node* left;
    struct Node* right;
};

struct Node* create(int value);
struct Node* insert(struct Node* root, int value);
struct Node* removeNode(struct Node* root, int value);
struct Node* find(struct Node* root, int value);
struct Node* find_successor(struct Node* node);

void inorder(struct Node* root);
void preorder(struct Node* root);
void postorder(struct Node* root);
