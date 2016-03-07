#include <fstream>
#include <iostream>
#include <vector>

using namespace std;

class Node {
public:
    int value;
    int weight;
    Node(int value, int weight) : weight(weight), value(value) {};
};

class NodeResult {
public:
    int total_value;
    string total_digit;
    NodeResult() : total_value(0) {};
};

int main(int argc, char** argv) {

    ifstream file(argv[1]);

    vector<Node> nodes;

    int count = 0;
    int weight_r, value_r;
    while (file >> value_r >> weight_r) {
        nodes.push_back(Node(value_r, weight_r));
        count++;
    }

    NodeResult table[7][101];

    for (int i = 1; i <= count; i++) {
        int weight_t = nodes[i-1].weight;
        int value_t = nodes[i-1].value;
        for (int j = weight_t; j <= 100; j++) {
            if ((value_t + table[i-1][j-weight_t].total_value) > table[i-1][j].total_value) {
                table[i][j].total_value = value_t + table[i-1][j-weight_t].total_value;
                table[i][j].total_digit = table[i-1][j-weight_t].total_digit + to_string(i);
            } else {
                table[i][j].total_value = table[i-1][j].total_value;
                table[i][j].total_digit = table[i-1][j].total_digit;
            }
        }
    }

    cout << "First let's see the diagram for this knapsack problem:" << endl;
    cout << endl;

    cout << "    ";

    for (int i = 0; i <= 6; i++) {
        if (i < 10) cout << i << "  ";
        else cout << i << " ";
    }

    cout << endl;

    for (int j = 0; j <= 100; j++) {
        if (j < 10) {
            cout << j << "   ";
        } else if (10 <= j && j < 100) {
            cout << j << "  ";
        } else {
            cout << j << " ";
        }

        for (int i = 0; i <= 6; i++) {
            if (table[i][j].total_value < 10) cout << table[i][j].total_value << "  ";
            else cout << table[i][j].total_value << " ";
        }
        cout << endl;
    }

    cout << endl;
    cout << "The final result is:" << endl;
    cout << endl;

    cout << "value is " << table[6][100].total_value << ", task is " << table[6][100].total_digit;

    return 0;
}