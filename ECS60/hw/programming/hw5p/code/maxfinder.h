// Author: Zhen Zhang
#ifndef maxfinderH
#define maxfinderH

#define INF 100
#define white 0
#define gray 1
#define black 2
#define hashGap 40
#define IPDomain 256
#define hashSize hashGap*IPDomain

#include "NetDriver.h"
#include <iostream>

class Address {
public:
    char address[16];

    Address(const char t_address[16]) {
        for (int i = 0; i < 16; i++) {
            address[i] = t_address[i];
        }
    };

    Address() {};

    int addressTotal(int& initial);
};

class EdgeExtended {
public:
    int src;
    int dest;
    int capacity;
    int flow;
    int inverse_index;

    EdgeExtended(int src, int dest, int capacity, int inverse_index) :
        src(src), dest(dest), capacity(capacity), flow(0), inverse_index(inverse_index)
    {};

    EdgeExtended() {};
};

class IPHashTable {
public:
    Address* array;
    int total_check[hashSize];
    int size[hashSize];
    int start_index[hashSize];
    int end_index[hashSize];
    int current_index[hashSize];

    IPHashTable () {
        for (int i = 0; i < hashSize; i++) {
            total_check[i] = -1;
            size[i] = 0;
        }

        array = new Address[hashSize];
    };

    int findPos(Address& address) {
        int initial = 0;
        int address_total = address.addressTotal(initial);
        int begin = hashGap * initial;
        int check_sum = 0;

        while ((check_sum = total_check[begin]) != -1) {
            if (check_sum == address_total && identicalIP(address.address, array[begin].address)) {
                return begin;
            }
            begin++;
        }

        return begin;
    }

    bool identicalIP(const char* address1, const char* address2) const {
        int i = 0;
        while (address1[i] != '\0' || address2[i] != '\0') {
            if (address1[i] != address2[i]) return false;
            i++;
        }
        return true;
    }

    void find(int index, int& start, int& end) {
        start = start_index[index];
        end = end_index[index];
    }

    void addEdge(Edge& edge, EdgeExtended* t_vector) {
        Address address1(edge.src);
        Address address2(edge.dest);

        int index1 = findPos(address1);
        int pos1 = current_index[index1]++;
        int index2 = findPos(address2);
        int pos2 = current_index[index2]++;

        t_vector[pos1] = EdgeExtended(index1, index2, edge.capacity, pos2);
        t_vector[pos2] = EdgeExtended(index2, index1, 0, pos1);

        return;
    }

    void insert(Address& address) {
        int initial = 0;
        int address_total = address.addressTotal(initial);
        int begin = hashGap * initial;
        int check_sum = 0;

        while ((check_sum = total_check[begin]) != -1) {
            if (check_sum == address_total && identicalIP(address.address, array[begin].address)) {
                size[begin]++;
                return;
            }
            begin++;
        }

        array[begin] = Address(address.address);
        total_check[begin] = address_total;
        size[begin]++;
        return;
    };

    void insert(Edge& edge) {
        Address address1 = Address(edge.src);
        Address address2 = Address(edge.dest);
        insert(address1);
        insert(address2);
    }

    void calculateIndex() {
        int total_count = 0;
        for (int i = 0; i < IPDomain; i++) {
            int index = hashGap * i;
            while (size[index] != 0) {
                start_index[index] = total_count;
                current_index[index] = total_count;
                total_count += size[index];
                end_index[index++] = total_count;
            }
        }
    }
};

class MaxFinder
{
public:
    const Computer* computers;
    int numComputers, numTerminals;

    Address* terminals;
    Address final_address;

    int color[hashSize];
    int pre[hashSize];
    int preEdge[hashSize];

    MaxFinder(const Computer *tcomputers, int numComputers, int numTerminals);

    int calcMaxFlow(Edge *edges, int numEdges);

    void calcMaxFlow(int& max_flow, int final_pos, EdgeExtended* new_edges);

    int min(int s1, int s2) { return s1 < s2 ? s1 : s2; }

    bool dfs_preparation(int src, IPHashTable& hashTable, EdgeExtended* new_edges, int final_pos);

    bool dfs(int src, IPHashTable& hashTable, EdgeExtended* new_edges, int final_pos);

}; // class MaxFinder

#endif
