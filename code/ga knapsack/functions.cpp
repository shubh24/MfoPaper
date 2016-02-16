#include "structures.h"

void init_population(ga_vector &population, ga_vector &buffer, int items)
{
	for (int i=0; i < GA_POPSIZE; i++) {
		option citizen;
		citizen.fitness = 0;
		citizen.chosen = new bool[items];
		for (int j=0; j<items; j++)
			citizen.chosen[j] = rand() % 2;

		buffer.push_back(citizen);
		population.push_back(citizen);
	}
}

void calc_fitness(ga_vector &population, data &dat){
	int value, weight, items = dat[0].value, max_weight = dat[0].weight;
	for(int i = 0; i < GA_POPSIZE; i++){
		value = 0, weight = 0;
		for(int j = 0; j < items; j++){
			value += population[i].chosen[j] * dat[j+1].value;
			weight += population[i].chosen[j] * dat[j+1].weight;
		}

		if (weight > max_weight)
			population[i].fitness = 0;

		else
			population[i].fitness = value;
	}
}

void readfile(data &dat, const string filename){
	object first;
	ifstream file(filename.c_str());
	int value, weight, count1, i = 1;
	file >> first.value;
	file >> first.weight;
	dat.push_back(first);
	count1 = dat[0].value;
	//cout << dat[0].value << " " << dat[0].weight << endl;
	while(i <= count1){
		object curr;
		file >> value;
		file >> weight;
		curr.value = value;
		curr.weight = weight;
		dat.push_back(curr);
		//cout << dat[i].value << " " << dat[i].weight << endl;
		i++;
	}
}

void print_best(ga_vector &population, int cnt){
	for(int j = 0; j < cnt; j++)
		cout << population[0].chosen[j];
	cout << " " << population[0].fitness << endl;
}


bool fitness_sort(option x, option y)
{
	return (x.fitness > y.fitness);
}

void sort_by_fitness(ga_vector &population)
{
	sort(population.begin(), population.end(), fitness_sort);
}

void elitism(ga_vector &population,	ga_vector &buffer, int esize)
{
	for (int i=0; i<esize; i++) {
		buffer[i].chosen = population[i].chosen;
		buffer[i].fitness = population[i].fitness;
	}
}

void mutate(option &member, int cnt)
{
	int tsize = cnt;
	int ipos = rand() % tsize;
	member.chosen[ipos] = rand() % 2;
}

void mate(ga_vector &population, ga_vector &buffer, int cnt)
{
	int esize = GA_POPSIZE * GA_ELITRATE;
	int tsize = cnt;

	elitism(population, buffer, esize);

	// Mate the rest
	for (int i = esize; i < GA_POPSIZE; i++) {
		mix(population[i], buffer[i], tsize);
		if (rand() < GA_MUTATION)
			mutate(buffer[i], tsize);
	}
}

void mix(option x, option y, int cnt){
	for(int i = 0; i < cnt; i++)
		y.chosen[i] = y.chosen[i] ^ x.chosen[i];
}

void swap(ga_vector *&population, ga_vector *&buffer)
{
	ga_vector *temp = population;
	population = buffer;
	buffer = temp;
}
