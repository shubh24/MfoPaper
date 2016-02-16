#include<vector>
#include<iostream>
#include<string>
#include<fstream>
#include<algorithm>
#include<time.h>
#include<math.h>
#include<sys/time.h>
#include<stdlib.h>
#include<random>

#define No_of_Bats  20
#define freq_max 1.0f
#define freq_min 0.0f

using namespace std;

struct object {
    int value;
    int weight;
};

struct bat {
    bool *loc;
    int fitness;
    int id;
};

typedef vector<bat> bat_vector;
typedef vector<object> data;

struct population{
    int items;
    double *freq;
    double *rate;
    int *velocity;
    bat_vector bats;
    bat best;
};


void readfile(data &dat, const string filename);
void initialize_population(population &pop, int items);
int distance(bat x, bat y, int items);
void calc_fitness(population &pop, data &dat);
void move_bat(bat x, int distance, data dat);

bat get_best(population &pop);
void print(population &pop);
void new_solutions(population &pop, data dat);
int fitness(bat b, data &dat);
float getrand();
