#include <iostream>
#include <fstream>
#include "StackAr.h"
#include "QueueAr.h"

using namespace std;

struct Person {
    int row_num;
    char seat_num;
};

class Row {
public:
    StackAr<Person> left, right;
    char status;
    // EMPTY: 0, WAITING_TO_MOVE: 1, STORING_LUGGAGE1: 2, STORING_LUGGAGE2: 3,
    // AC_OUT: 4, DF_IN: 5,
    StackAr<Person> aisle;
    Row();
};

Row::Row() {
    status = 0;
}

void row_update(StackAr<Row>&, bool*);
void auxiliary_row_update(StackAr<Row>&, StackAr<Row>&, int, bool*);
void boarding_pass(ifstream&, const char*);

void row_update(StackAr<Row>& rows, bool* empty_flag) {
    int index_temp = 49;
    StackAr<Row> auxiliary_row(index_temp);

    while (index_temp > 0) {
        Row row = rows.topAndPop();
        auxiliary_row.push(row);
        --index_temp;
    }

    int index_temp_auxiliary = 48;
    while (index_temp_auxiliary > 0) {
        auxiliary_row_update(rows, auxiliary_row, index_temp_auxiliary, empty_flag);
        --index_temp_auxiliary;
    }

}

void auxiliary_row_update(StackAr<Row>& rows, StackAr<Row>& auxiliary_row, int index, bool* empty_flag) {
    Row row_high = auxiliary_row.topAndPop();
    Row row_low = auxiliary_row.topAndPop();

    if (row_low.status != 0)
        *empty_flag = false;

    if (row_low.status == 1) {
        if (row_low.aisle.top().row_num == index)
            row_low.status = 2;
        else {
            if (row_high.status == 0) {
                row_low.status = 0;
                row_high.status = 1;
                row_high.aisle.push(row_low.aisle.topAndPop());
            }
        }
    }


    else if (row_low.status == 2)
        row_low.status = 3;

    else if (row_low.status == 3) {
        Person waiting_person = row_low.aisle.topAndPop();
        char waiting_person_seat_num = waiting_person.seat_num;
        if (waiting_person_seat_num == 'C') {
            row_low.left.push(waiting_person);
            row_low.status = 0;
        }
        else if (waiting_person_seat_num == 'D') {
            row_low.right.push(waiting_person);
            row_low.status = 0;
        }
        else if (waiting_person_seat_num == 'B') {
            if (row_low.left.isEmpty()) {
                row_low.left.push(waiting_person);
                row_low.status = 0;
            }
            else {
                if (row_low.left.top().seat_num == 'A') {
                    row_low.left.push(waiting_person);
                    row_low.status = 0;
                }
                else {
                    row_low.aisle.push(row_low.left.topAndPop());
                    row_low.aisle.push(waiting_person);
                    row_low.status = 4;
                }
            }
        }
        else if (waiting_person_seat_num == 'E') {
            if (row_low.right.isEmpty()) {
                row_low.right.push(waiting_person);
                row_low.status = 0;
            }
            else {
                if (row_low.right.top().seat_num == 'F') {
                    row_low.right.push(waiting_person);
                    row_low.status = 0;
                }
                else {
                    row_low.aisle.push(row_low.right.topAndPop());
                    row_low.aisle.push(waiting_person);
                    row_low.status = 4;
                }
            }
        }
        else if (waiting_person_seat_num == 'A') {
            if (row_low.left.isEmpty()) {
                row_low.left.push(waiting_person);
                row_low.status = 0;
            }
            else {
                row_low.aisle.push(row_low.left.topAndPop());
                row_low.aisle.push(waiting_person);
                row_low.status = 4;
            }
        }
        else if (waiting_person_seat_num == 'F') {
            if (row_low.right.isEmpty()) {
                row_low.right.push(waiting_person);
                row_low.status = 0;
            }
            else {
                row_low.aisle.push(row_low.right.topAndPop());
                row_low.aisle.push(waiting_person);
                row_low.status = 4;
            }
        }
    }

    else if (row_low.status == 4) {
        Person waiting_person = row_low.aisle.topAndPop();
        char waiting_person_seat_num = waiting_person.seat_num;
        if (waiting_person_seat_num == 'B') {
            row_low.left.push(waiting_person);
            row_low.status = 5;
        }
        else if (waiting_person_seat_num == 'E') {
            row_low.right.push(waiting_person);
            row_low.status = 5;
        }
        else if (waiting_person_seat_num == 'A') {
            if (row_low.left.isEmpty()) {
                row_low.left.push(waiting_person);
                row_low.status = 5;
            }
            else {
                row_low.aisle.push(row_low.left.topAndPop());
                row_low.aisle.push(waiting_person);
            }
        }
        else if (waiting_person_seat_num == 'F') {
            if (row_low.right.isEmpty()) {
                row_low.right.push(waiting_person);
                row_low.status = 5;
            }
            else {
                row_low.aisle.push(row_low.right.topAndPop());
                row_low.aisle.push(waiting_person);
            }
        }
    }

    else if (row_low.status == 5) {
        Person waiting_person = row_low.aisle.topAndPop();
        char waiting_person_seat_num = waiting_person.seat_num;
        if (waiting_person_seat_num == 'B' || waiting_person_seat_num == 'A' || waiting_person_seat_num == 'C') {
            row_low.left.push(waiting_person);
        }
        else if (waiting_person_seat_num == 'D' || waiting_person_seat_num == 'E' || waiting_person_seat_num == 'F') {
            row_low.right.push(waiting_person);
        }

        if (row_low.aisle.isEmpty())
            row_low.status = 0;
    }

    rows.push(row_high);
    if (index == 1)
        rows.push(row_low);
    else
        auxiliary_row.push(row_low);
}

void boarding_pass(ifstream& file, const char* print_char) {

    Queue<Person> waiting_persons(288);
    int count_temp = 288;
    int row_num;
    char seat_num;

    while (count_temp > 0 && file >> row_num >> seat_num) {
        Person person ={
                row_num,
                seat_num,
        };
        waiting_persons.enqueue(person);
        --count_temp;
    }

    int num_row = 49;
    StackAr<Row> rows(num_row);
    while (num_row > 0) {
        Row row;
        rows.push(row);
        --num_row;
    }

    int count = 0;

    bool empty_flag = false;
    while (!waiting_persons.isEmpty() || !empty_flag) {
        empty_flag = true;
        row_update(rows, &empty_flag);
        if (rows.top().status == 0 && !waiting_persons.isEmpty()) {
            Row row_top = rows.topAndPop();
            row_top.aisle.push(waiting_persons.dequeue());
            row_top.status = 1;
            rows.push(row_top);
        }
        ++count;
    }

    cout << print_char << ": " << (count - 1) * 5 << endl;

}

int main(int argc, char** argv) {

    ifstream file(argv[1]);

    boarding_pass(file, "Back to front");
    boarding_pass(file, "Random");
    boarding_pass(file, "Outside in");

    return 0;
}//
// Created by Elliot on 1/14/16.
//

