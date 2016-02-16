#include<vector>
#include<iostream>
#include<string>
#include<fstream>
#include<algorithm>
#include<time.h>
#include<math.h>
#include<sys/time.h>
#include<stdlib.h>

#define GA_POPSIZE		3500		// ga population size
#define GA_MAXITER		2000		// maximum iterations
#define GA_ELITRATE		0.25f		// elitism rate
#define GA_MUTATIONRATE		0.40f		// mutation rate
#define GA_MUTATION		RAND_MAX * GA_MUTATIONRATE

using namespace std;

struct object{
	int value;
	int weight;
};

struct option{
	bool *chosen;
	int fitness;
};

typedef vector<option> ga_vector; // population
typedef vector<object> data;	//data contains info about all objects

void init_population(ga_vector &population, ga_vector &buffer, int items);
void calc_fitness(ga_vector &population, data &dat);
bool fitness_sort(option x, option y);
void sort_by_fitness(ga_vector &population);
void elitism(ga_vector &population, ga_vector &buffer, int esize);
void mutate(option &member, int cnt);

void mate(ga_vector &population, ga_vector &buffer, int cnt);
void swap(ga_vector &population, ga_vector &buffer);
void readfile(data &dat, const string filename);
void print_best(ga_vector &population, int cnt);
void mix(option x, option y, int cnt);
