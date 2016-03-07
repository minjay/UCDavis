//
// Created by Elliot on 1/30/16.
//

#include <iostream>
#include <fstream>
#include "BinaryHeap.h"
#include "BinaryTree.h"

using namespace std;

//---------------Definition of class Node-----------------//

class Node
{
public:
    int count;
    char identifier;
    Node* next;
    Node();
    Node(char character, int number);
    Node merge(Node node);
    friend ostream& operator<< (ostream &os, const Node& node);
    bool operator< (const Node& node) const;
    bool operator== (const Node& node) const;
};

Node::Node() : count(0) { }

Node::Node(char character, int number) : count(number), identifier(character) { }

Node Node::merge(Node node) {
    char character = '\0';
    Node nodeNew(character, count+node.count);
    return nodeNew;
}

ostream& operator<< (ostream &os, const Node& node) {
    return os << node.identifier << ' ' << node.count;
}

bool Node::operator< (const Node &node) const {
    return count < node.count;
}

bool Node::operator==(const Node &node) const {
    return count == node.count;
}

//---------------Definition of class Dictionary-----------------//

class Dictionary
{
public:
    Node* header;
    int count;
    Dictionary();
    void insert(const char character);
    bool isEmpty();
    Node* pop();
};

Dictionary::Dictionary() : header(new Node()), count(0) { }

void Dictionary::insert(char character) {
    Node* ptr = header;
    int i = 0;

    while (header->identifier != character) {
        if (i < count) {
            header = header->next;
            i++;
        }
        else {
            Node* node = new Node(character, 1);
            header->next = node;
            header = ptr;
            count++;
            return;
        }
    }
    header->count++;

    header = ptr;
}

bool Dictionary::isEmpty() {
    return count == 0;
}

Node* Dictionary::pop() {
    Node* ptr = header->next;
    header->next = ptr->next;
    count--;
    return ptr;
}

//--------define heap merge function, since I could not edit BinaryHeap.cpp-------//

template <class Comparable>
BinaryTree<Comparable>* mergeHeap(BinaryHeap<BinaryTree<Comparable> >& binaryHeap) {
    while (true) {
        BinaryTree<Comparable> *popTree1 = new BinaryTree<Comparable>;
        binaryHeap.deleteMin(*popTree1);
        if (!binaryHeap.isEmpty()) {
            BinaryTree<Comparable> *popTree2 = new BinaryTree<Comparable>;
            binaryHeap.deleteMin(*popTree2);
            BinaryTree<Comparable>* insertTree = popTree1->merge(popTree2);
            binaryHeap.insert(*insertTree);
        } else {
            return popTree1;
        }
    }
}

//------------------main function---------------------------//

int main(int argc, char** argv) {

    ifstream file(argv[1]);

    Node* header = new Node();
    Dictionary dict;
    char character;

    while (file >> noskipws >> character) {
        dict.insert(character);
    }

    BinaryHeap<BinaryTree<Node> > binaryHeap(100);

    while (!dict.isEmpty()) {
        Node* ptr = dict.pop();
        BinaryTree<Node> binaryTree(*ptr, NULL, NULL);
        binaryHeap.insert(binaryTree);
    }

    BinaryTree<Node>* finalTree = mergeHeap(binaryHeap);

    char encoding[30];
    finalTree->getCode(encoding, 0);

}