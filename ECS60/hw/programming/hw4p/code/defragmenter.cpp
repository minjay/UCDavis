//
// Created by Elliot on 2/12/16.
//

#include "defragmenter.h"

template <class T, int N>
class HashTable{
public:
    int size;
    int current_size;
    vector<T> array;
    bool index_array[N];
    HashTable(const vector<T>& array) : size(N), current_size(0), array(array) { };

    int insert(T& t, int pos) {
        if (current_size == size) return 0;
        pos = pos % size;
        int limit = 100;
        int count = 0;
        while (index_array[pos] && count < limit) {
            pos++;
            pos = pos % size;
            count++;
        }
        if (count == limit) return 0;
        else {
            array[pos] = t;
            index_array[pos] = true;
            current_size++;
            return -pos;
        }
    }

    void set(T& t, int pos) {
        array[pos] = t;
        index_array[pos] = true;
    }

    T& remove(int pos) {
        index_array[pos] = false;
        current_size--;
        return array[pos];
    }
};

Defragmenter::Defragmenter(DiskDrive *diskDrive) {

    int array[diskDrive->getCapacity()];
    for (int i = 0; i < diskDrive->getCapacity(); i++) array[i] = 0;

    const int random_size = 30;

    vector<DiskBlock*> hashArray(random_size);
    HashTable<DiskBlock*, random_size> hashTable(hashArray);

    int disk_file_size = diskDrive->getNumFiles();
    unsigned traverse_pos = 2;
    int current_pos = 0;
    int new_pos = 0;
    int firstBlockID, size;
    bool fat2;

    int total_residence = 2;
    for (int i = 0; i < diskDrive->getNumFiles(); i++) {
        total_residence += diskDrive->directory[i].getSize();
    }
    QueueLL<int> residence_queue;
    int total_residence_copy = total_residence;
    for (; total_residence_copy < diskDrive->getCapacity(); total_residence_copy++) {
        if (!diskDrive->FAT[total_residence_copy]) residence_queue.enqueue(total_residence_copy);
    }

    for (int i = 0; i < disk_file_size; i++) {
        firstBlockID = diskDrive->directory[i].getFirstBlockID();
        size = diskDrive->directory[i].getSize();
        current_pos = firstBlockID;
        diskDrive->directory[i].setFirstBlockID(traverse_pos);

        for (int j = 0; j < size; j++) {
//            cout << traverse_pos << endl;
            if (traverse_pos == 80)
                cout << "hello" << endl;

            new_pos = array[current_pos];

            DiskBlock *db1;
            DiskBlock *db2;

            if (new_pos > total_residence) {
                residence_queue.enqueue(new_pos);
            } else {
                while (new_pos > 0) {
                    array[current_pos] = 0;
                    current_pos = new_pos;
                    new_pos = array[current_pos];
                }

                if (new_pos == 0) {
                    db1 = diskDrive->readDiskBlock(current_pos);
                } else {
                    db1 = hashTable.remove(-new_pos);
                }
            }

            fat2 = diskDrive->FAT[traverse_pos];
            diskDrive->FAT[current_pos] = false;
            diskDrive->FAT[traverse_pos] = true;


            if (fat2) {
                db2 = diskDrive->readDiskBlock(traverse_pos);

                int insert_result;

                if (new_pos == 0) {
                    insert_result = hashTable.insert(db2, current_pos);

                    if (insert_result == 0) {

                        if (!residence_queue.isEmpty()) {
                            int residence_index = residence_queue.dequeue();
                            diskDrive->writeDiskBlock(db2, residence_index);
                            array[traverse_pos] = residence_index;
                            diskDrive->FAT[current_pos] = fat2;
                            delete db2;
                        } else {
                            diskDrive->writeDiskBlock(db2, current_pos);
                            array[traverse_pos] = current_pos;
                            diskDrive->FAT[current_pos] = fat2;
                            delete db2;
                        }

                    } else {
                        array[traverse_pos] = insert_result;
                    }

                } else {
                    hashTable.set(db2, -new_pos);
                    array[traverse_pos] = new_pos;
                }

            }

            current_pos = db1->getNext();
            if (current_pos == 1) db1->setNext(1);
            else db1->setNext(traverse_pos+1);
            diskDrive->writeDiskBlock(db1, traverse_pos);
            delete db1;

            traverse_pos++;

//            cout << diskDrive->getDiskAccesses() << endl;

//            cout << "LOOP " << traverse_pos << endl;
//            for (int k = 0; k < 100; k++) {
//                cout << diskDrive->readDiskBlock(k) << endl;
//            }
//            cout << "THE END" << endl;
        }
    }
}