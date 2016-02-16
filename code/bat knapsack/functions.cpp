#include "structures.h"

void readfile(data &dat, const string filename)
{
    object first;
    ifstream file(filename.c_str());
    int value, weight, count1, i = 1;
    file >> first.value;
    file >> first.weight;
    dat.push_back(first);
    count1 = dat[0].value;
    //cout << dat[0].value << " " << dat[0].weight << endl;
    while(i <= count1)
    {
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

void initialize_population(population &pop, int item)
{
    int items = item;
    pop.freq = new double[No_of_Bats];
    pop.rate = new double[No_of_Bats];
    pop.velocity = new int[No_of_Bats];
    pop.items = item;

    for(int i = 0; i < No_of_Bats; i++)
    {
        bat curr;
        curr.id = i + 1;
        curr.loc = new bool[items];
        curr.fitness = 0;

        for(int j = 0; j < items; j++)
            curr.loc[j] = rand() % 2;

        pop.bats.push_back(curr);

        pop.freq[i] = 0;
        pop.velocity[i] = 0;
        pop.rate[i] = 0;
    }
}

int distance(bat x, bat y, int items)
{
    int dist = 0;
    for(int i = 0; i < items; i++)
    {
        if(x.loc[i] == y.loc[i])
            dist += 1;
    }
    return dist;
}

void print(population &pop)
{
    for(int i = 0; i < No_of_Bats; i++)
    {
        cout << "bat " << pop.bats[i].id << " fitness = " << pop.bats[i].fitness << endl;
        cout << "(speed, freq, rate) = (" << pop.velocity[i] << ", " << pop.freq[i] << ", " << pop.rate[i] << ")" << endl;
        cout << endl;
    }
}

void calc_fitness(population &pop, data &dat)
{
    for(int i = 0; i < No_of_Bats; i++)
    {
        pop.bats[i].fitness = fitness(pop.bats[i], dat);
    }
}


void move_bat(bat curr, int distance, data dat)
{
    int i, pos, items = dat[0].value;
    bat x = curr;
    x.fitness = 1;
    while(x.fitness > 0)
    {
        for(i = 0; i < distance; i++)
        {
            pos = rand()%items;
            x.loc[pos] = rand() % 2;
            //cout << 1;
        }
        x.fitness = fitness(x, dat);
    }
    curr = x;
}

void new_solutions(population &pop, data dat)
{
    int items = pop.items;

    for(int i = 0; i < items; i++)
    {
        pop.freq[i] = freq_min + (freq_max - freq_min)*getrand();
        pop.velocity[i] = (int)distance(pop.bats[i], pop.bats[0], items)*pop.freq[i];
        move_bat(pop.bats[i], pop.velocity[i], dat);
        pop.rate[i] = 0.5;
    }
}

bat get_best(population &p)
{
    int i, fit = 0;
    bat best;
    for(i = 0; i < No_of_Bats; i++){
        if(p.bats[i].fitness > fit)
            best = p.bats[i];
    }
    return best;
}

int fitness(bat b, data &dat)
{
    int items = dat[0].value, value = 0, weight = 0, max_weight = dat[0].weight;
    for(int j = 0; j < items; j++)
    {
        value += b.loc[j] * dat[j+1].value;
        weight += b.loc[j] * dat[j+1].weight;
    }
    if (weight > max_weight)
        return 0;

    else
        return value;
}

float getrand(){
    float r = static_cast <float> (rand()) / static_cast <float> (RAND_MAX);
    return r;
}

