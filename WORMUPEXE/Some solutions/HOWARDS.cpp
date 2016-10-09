/*
 *  Code for hogwarts.
 *
 *  Author: Giada Franz
 *
 *  Description: O(m + max_time)-time solution using BFS + sweeping line on time
 *
 */

#include <vector>
#include <iostream>

using namespace std;

const int INF = 1000000000;
const int MAX_TIME = 5000000;
const int MAXN = 1000000;

vector < pair <int, int> > edges_[MAXN+1];

vector <int> reached_[MAX_TIME+1];
bool done_[MAXN+1];
int distance_[MAXN+1];

int raggiungi(int N, int M, int A[], int B[], int appear[], int disappear[]) {

    for (int i = 0; i < M; i++) {
        edges_[A[i]].push_back(make_pair(i, B[i]));
        edges_[B[i]].push_back(make_pair(i, A[i]));
    }

    for (int i = 0; i < N; i++) {
        done_[i] = false;
        distance_[i] = INF;
    }

    reached_[0].push_back(0);
    distance_[0] = 0;

    for (int t = 0; t <= MAX_TIME; t++) {
        for (int v : reached_[t]) {
            if (!done_[v]) {
                for (auto edge : edges_[v]) {
                    int staircase = edge.first;
                    int neighbor = edge.second;
                    int time = max(distance_[v], appear[staircase])+1;
                    if (!done_[neighbor] and distance_[v] < disappear[staircase] and time < distance_[neighbor]) {
                        distance_[neighbor] = time;
                        reached_[time].push_back(neighbor);
                    }
                }
                done_[v] = true;
            }
        }
    }
    return (distance_[N-1] == INF)? -1 : distance_[N-1];
}
