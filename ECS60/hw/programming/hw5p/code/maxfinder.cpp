// Author: Zhen Zhang, Luhong Pan

#include "NetDriver.h"
#include "maxfinder.h"

using namespace std;

int Address::addressTotal(int& initial) {

  int series[4];
  for (int i = 0; i < 4; i++) {
    series[i] = 0;
  }

  int dot_count = 0;
  int total = 0;
  for (int i = 0; i < 16; i++) {
    if (address[i] == '\0') break;
    if (address[i] == '.') {
      total += series[dot_count++];
    }
    else {
      int x = address[i] - '0';
      series[dot_count] = series[dot_count] * 10 + x;
    }
  }

  initial = series[0];
  return total;
}

MaxFinder::MaxFinder(const Computer *tcomputers, int numComputers, int numTerminals) :
        computers(tcomputers), numComputers(numComputers), numTerminals(numTerminals),
        final_address(Address(tcomputers[numComputers-1].address))
{
  Address* terminals_cp = new Address[numTerminals];
  for (int i = 0; i < numTerminals; i++) {
    terminals_cp[i] = Address(computers[i].address);
  }
  terminals = terminals_cp;
} // MaxFinder()

void MaxFinder::calcMaxFlow(int& max_flow, int final_pos, EdgeExtended* new_edges) {

  int result = INF;

  for (int i = final_pos; pre[i] >= 0; i = pre[i]) {
    int edge_pos = preEdge[i];
    result = min(result, new_edges[edge_pos].capacity - new_edges[edge_pos].flow);
  }

  for (int i = final_pos; pre[i] >= 0; i = pre[i]) {
    int edge_forward = preEdge[i];
    int edge_backward = new_edges[edge_forward].inverse_index;
    new_edges[edge_forward].flow += result;
    new_edges[edge_backward].flow -= result;
  }

  max_flow += result;
}

bool MaxFinder::dfs_preparation(int src, IPHashTable& hashTable, EdgeExtended* new_edges, int final_pos) {
  for (int i = 0; i < hashSize; i++) {
    color[i] = white;
    pre[i] = -1;
  }

  return dfs(src, hashTable, new_edges, final_pos);
}

bool MaxFinder::dfs(int src, IPHashTable& hashTable, EdgeExtended* new_edges, int final_pos) {
  if (src == final_pos)
    return true;

  color[src] = gray;
  int start, end;
  hashTable.find(src, start, end);
  for (int i = start; i < end; i++) {
    EdgeExtended new_edge = new_edges[i];
    int aim_pos = new_edge.dest;
    if (color[aim_pos] == white && new_edge.capacity > new_edge.flow) {
      pre[aim_pos] = src;
      preEdge[aim_pos] = i;
      if (dfs(aim_pos, hashTable, new_edges, final_pos)) return true;
    }
  }
  color[src] = black;

  return false;
}

int MaxFinder::calcMaxFlow(Edge *edges, int numEdges)
{

  IPHashTable hashTable;
  for (int i = 0; i < numEdges; i++) {
    hashTable.insert(edges[i]);
  }
  hashTable.calculateIndex();

  EdgeExtended *new_edges = new EdgeExtended[2 * numEdges];
//  vector<EdgeExtended*> new_edges(2 * numEdges);
  for (int i = 0; i < numEdges; i++) {
    hashTable.addEdge(edges[i], new_edges);
  }

  int final_pos = hashTable.findPos(final_address);
  int terminal_table[numTerminals];
  for (int i = 0; i < numTerminals; i++) {
    Address address(terminals[i].address);
    terminal_table[i] = hashTable.findPos(address);
  }

  int max_flow = 0;
  bool flag = true;


  int counter = 0;

  for (int i = 0; i < numTerminals; i++) {
    while (dfs_preparation(terminal_table[i], hashTable, new_edges, final_pos)) {
      counter++;
      calcMaxFlow(max_flow, final_pos, new_edges);
    }
  }

  while (flag) {
    flag = false;
    for (int i = 0; i < numTerminals; i++) {
      counter++;
      if (dfs_preparation(terminal_table[i], hashTable, new_edges, final_pos)) {
        flag = true;
        calcMaxFlow(max_flow, final_pos, new_edges);
      }
    }
  }

  cout << counter << endl;

  return max_flow;  // bad result :(
} // calcMaxFlow()
