#include <fstream>
#include <iostream>
#include "LinkedList.h"
#include "CursorList.h"
#include "StackAr.h"
#include "StackLi.h"
#include "QueueAr.h"
#include "SkipList.h"
#include "CPUTimer.h"
vector<CursorNode <int> > cursorSpace(500001);

using namespace std;

int getChoice() {
    cout << endl;
    cout << "       ADT Menu" << endl;
    cout << "0. Quit" << endl;
    cout << "1. LinkedList" << endl;
    cout << "2. CursorList" << endl;
    cout << "3. StackAr" << endl;
    cout << "4. StackLi" << endl;
    cout << "5. QueueAr" << endl;
    cout << "6. SkipList" << endl;
    cout << "Your choice >> ";

    int choice;
    cin >> choice;

    return choice;
}

void RunList(char* file_name) {
    List<int> list;
    ListItr<int> listItr = list.zeroth();

    ifstream file(file_name);
    string str;
    getline(file, str);
    char command;
    int value;
    while (file >> command >> value) {
        if (command == 'i')
            list.insert(value, listItr);
        else
            list.remove(value);
    }
}

void RunCursorList(char* file_name) {
    CursorList<int> cursorList(cursorSpace);
    CursorListItr<int> cursorListItr = cursorList.zeroth();

    ifstream file(file_name);
    string str;
    getline(file, str);
    char command;
    int value;
    while (file >> command >> value) {
        if (command == 'i')
            cursorList.insert(value, cursorListItr);
        else
            cursorList.remove(value);
    }
}

void RunStackAr(char* file_name) {
    StackAr<int> stackAr(500000);
    ifstream file(file_name);
    string str;
    getline(file, str);
    char command;
    int value;
    while (file >> command >> value) {
        if (command == 'i')
            stackAr.push(value);
        else
            stackAr.pop();
    }

}

void RunStackLi(char* file_name) {
    StackLi<int> stackLi;
    ifstream file(file_name);
    string str;
    getline(file, str);
    char command;
    int value;
    while (file >> command >> value) {
        if (command == 'i')
            stackLi.push(value);
        else
            stackLi.pop();
    }
}

void RunQueueAr(char* file_name) {
    Queue<int> queue(500000);
    ifstream file(file_name);
    string str;
    getline(file, str);
    char command;
    int value;
    while (file >> command >> value) {
        if (command == 'i')
            queue.enqueue(value);
        else
            queue.dequeue();
    }
}

void RunSkipList(char* file_name) {
    SkipList<int> skipList(0, 500000);
    ifstream file(file_name);
    string str;
    getline(file, str);
    char command;
    int value;
    while (file >> command >> value) {
        if (command == 'i')
            skipList.insert(value);
        else
            skipList.deleteNode(value);
    }
}

int main() {
    CPUTimer ct;

    cout << "Filename >> ";
    char file_name[8];
    cin >> file_name;

    int choice;

    do {
        choice = getChoice();

        ct.reset();

        switch(choice)
        {
            case 1: RunList(file_name); break;
            case 2: RunCursorList(file_name); break;
            case 3: RunStackAr(file_name); break;
            case 4: RunStackLi(file_name); break;
            case 5: RunQueueAr(file_name); break;
            case 6: RunSkipList(file_name); break;
        }

        cout << "CPU time: " << ct.cur_CPUTime() << endl;
    } while (choice > 0);

    return 0;
}
