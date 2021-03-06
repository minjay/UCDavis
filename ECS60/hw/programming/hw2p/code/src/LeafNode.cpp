#include <iostream>
#include <climits>
#include "LeafNode.h"
#include "InternalNode.h"
#include "QueueAr.h"

using namespace std;


LeafNode::LeafNode(int LSize, InternalNode *p,
  BTreeNode *left, BTreeNode *right) : BTreeNode(LSize, p, left, right)
{
  values = new int[LSize];
}  // LeafNode()

void LeafNode::addToLeft(int value, int last)
{
  leftSibling->insert(values[0]);

  for(int i = 0; i < count - 1; i++)
    values[i] = values[i + 1];

  values[count - 1] = last;
  if(parent)
    parent->resetMinimum(this);
} // LeafNode::ToLeft()

void LeafNode::addToRight(int value, int last)
{
  rightSibling->insert(last);

  if(value == values[0] && parent)
    parent->resetMinimum(this);
} // LeafNode::addToRight()

void LeafNode::addToThis(int value)
{
  int i;

  for(i = count - 1; i >= 0 && values[i] > value; i--)
      values[i + 1] = values[i];

  values[i + 1] = value;
  count++;

  if(value == values[0] && parent)
    parent->resetMinimum(this);
} // LeafNode::addToThis()


void LeafNode::addValue(int value, int &last)
{
  int i;

  if(value > values[count - 1])
    last = value;
  else
  {
    last = values[count - 1];

    for(i = count - 2; i >= 0 && values[i] > value; i--)
      values[i + 1] = values[i];
    // i may end up at -1
    values[i + 1] = value;
  }
} // LeafNode:: addValue()


int LeafNode::getMaximum()const
{
  if(count > 0)  // should always be the case
    return values[count - 1];
  else
    return INT_MAX;
} // getMaximum()


int LeafNode::getMinimum()const
{
  if(count > 0)  // should always be the case
    return values[0];
  else
    return 0;

} // LeafNode::getMinimum()


LeafNode* LeafNode::insert(int value)
{
  int last;

  if(count < leafSize)
  {
    addToThis(value);
    return NULL;
  } // if room for value

  addValue(value, last);

  if(leftSibling && leftSibling->getCount() < leafSize)
  {
    addToLeft(value, last);
    return NULL;
  }
  else // left sibling full or non-existent
    if(rightSibling && rightSibling->getCount() < leafSize)
    {
      addToRight(value, last);
      return NULL;
    }
    else // both siblings full or non-existent
      return split(value, last);
}  // LeafNode::insert()

void LeafNode::print(Queue <BTreeNode*> &queue)
{
  cout << "Leaf: ";
  for (int i = 0; i < count; i++)
    cout << values[i] << ' ';
  cout << endl;
} // LeafNode::print()

void LeafNode::removeFromThis(int value) {
  int index = 0;

  while(values[index] != value && index < count) {
    index++;
  }

  if (index == count)
    return;

  int index_flag = index;

  while(index < count - 1) {
    values[index] = values[index+1];
    index++;
  }

  count--;

  if (index_flag == 0 && parent)
    parent->resetMinimum(this);
}

void LeafNode::borrowFromLeft() {
  int last = leftSibling->getMaximum();
  leftSibling->remove(last);
  insert(last);
}

void LeafNode::borrowFromRight() {
  int first = rightSibling->getMinimum();
  rightSibling->remove(first);
  insert(first);
}

LeafNode* LeafNode::mergeLeft(LeafNode* sibling) {
  LeafNode *ptr = new LeafNode(leafSize, parent, sibling->leftSibling, rightSibling);

  for (int j = 0; j < sibling->getCount(); j++) {
    ptr->values[ptr->count++] = sibling->values[j];
  }

  for (int i = 0; i < count; i++) {
    ptr->values[ptr->count++] = values[i];
  }

  return ptr;
}

LeafNode* LeafNode::mergeRight(LeafNode* sibling) {
  LeafNode *ptr = new LeafNode(leafSize, parent, leftSibling, sibling->rightSibling);

  for (int i = 0; i < count; i++) {
    ptr->values[ptr->count++] = values[i];
  }

  for (int j = 0; j < sibling->getCount(); j++) {
    ptr->values[ptr->count++] = sibling->values[j];
  }

  return ptr;
}


LeafNode* LeafNode::remove(int value)
{   // To be written by students

  int threshold = (leafSize % 2) ? leafSize / 2 + 1 : leafSize / 2;

  removeFromThis(value);
  if (count >= threshold)
    return NULL;


  if (leftSibling) {
    if (leftSibling->getCount() > threshold) {
      borrowFromLeft();
      return NULL;
    } else {
      return mergeLeft((LeafNode*) leftSibling);
    }
  }

  else if (rightSibling) {
    if (rightSibling->getCount() > threshold) {
      borrowFromRight();
      return NULL;
    } else {
      return mergeRight((LeafNode*) rightSibling);
    }
  }

  else {
    return NULL;
  }

}  // LeafNode::remove()



LeafNode* LeafNode::split(int value, int last)
{
  LeafNode *ptr = new LeafNode(leafSize, parent, this, rightSibling);


  if(rightSibling)
    rightSibling->setLeftSibling(ptr);

  rightSibling = ptr;

  for(int i = (leafSize + 1) / 2; i < leafSize; i++)
    ptr->values[ptr->count++] = values[i];

  ptr->values[ptr->count++] = last;
  count = (leafSize + 1) / 2;

  if(value == values[0] && parent)
    parent->resetMinimum(this);
  return ptr;
} // LeafNode::split()

