//
// Created by Elliot on 1/30/16.
//

#ifndef ECS60P3_BINARYTREE_H
#define ECS60P3_BINARYTREE_H

#include <iostream>

using namespace std;

template <class Comparable>
class BinaryTree
{
public:
    Comparable object;
    BinaryTree<Comparable> *left_child;
    BinaryTree<Comparable> *right_child;
    BinaryTree();
    BinaryTree(const Comparable &, BinaryTree<Comparable> *, BinaryTree<Comparable> *);
    bool operator< (const BinaryTree <Comparable> &) const;
    bool operator== (const BinaryTree <Comparable> &) const;
    BinaryTree<Comparable>* merge(BinaryTree<Comparable>*);
    void getCode(char*, int);
};

template <class Comparable>
BinaryTree<Comparable>::BinaryTree() : left_child(NULL), right_child(NULL) {};

template <class Comparable>
BinaryTree<Comparable>::BinaryTree(const Comparable &object, BinaryTree<Comparable> *left_child, BinaryTree<Comparable> *right_child) :
        object(object), left_child(left_child), right_child(right_child) { }

template <class Comparable>
bool BinaryTree<Comparable>::operator< (const BinaryTree <Comparable> &binaryTree) const
{
    return object < binaryTree.object;
}

template <class Comparable>
bool BinaryTree<Comparable>::operator== (const BinaryTree <Comparable> &binaryTree) const
{
    return object == binaryTree.object;
};

template <class Comparable>
BinaryTree<Comparable>* BinaryTree<Comparable>::merge(BinaryTree<Comparable>* binaryTree)
{
    Comparable objectNew = object.merge(binaryTree->object);
    BinaryTree<Comparable>* binaryTreeNewPtr = new BinaryTree<Comparable>(objectNew, this, binaryTree);
    return binaryTreeNewPtr;
}

template <class Comparable>
void BinaryTree<Comparable>::getCode(char encoding[], int current)
{
    if (left_child != NULL)
    {
        encoding[current] = '0';
        left_child->getCode(encoding, current + 1);
    }

    if (right_child != NULL)
    {
        encoding[current] = '1';
        right_child->getCode(encoding, current + 1);
    }

    if (left_child == NULL && right_child == NULL)
    {
        cout << object << ' ';
        for (int i = 0; i < current; i++)
            cout << encoding[i];
        cout << endl;
    }
} // printTree()


#endif //ECS60P3_BINARYTREE_H