#include "structures.h"

int main()
{
    srand(time(NULL));
    data dat;
    readfile(dat, "../../data/ks_19_0");
    int items = dat[0].value;
    population *pop, popalpha;
    initialize_population(popalpha, items);
    pop = &popalpha;
    //print(*pop);

    bat best = get_best(*pop);

    int iterations = 200;
    while(iterations > 0){
        new_solutions(*pop,dat);
        calc_fitness(*pop, dat);
        if(getrand()> 0.5){
            best = get_best(*pop);
            move_bat(best, rand()%5, dat); // amplitude is 2
        }

        if(fitness(best, dat) > fitness((*pop).best, dat))
            (*pop).best = best;

        iterations--;
    }
    print(*pop);
}

