#include "./structures.h"

using namespace std;

int main()
{
    data dat;
    readfile(dat, "../../data/ks_19_0");
    timeval t1;

    ga_vector pop_alpha, pop_beta;
    ga_vector *population, *buffer;
    int tsize = dat[0].value;

    for(int count1 = 0; count1 < 20; count1++)
    {
        gettimeofday(&t1, NULL);
        srand(t1.tv_usec * t1.tv_sec);
        init_population(pop_alpha, pop_beta, dat[0].value);
        population = &pop_alpha;
        buffer = &pop_beta;
        for (int i = 0; i<GA_MAXITER; i++)
        {
            calc_fitness(*population, dat);	// calculate fitness
            sort_by_fitness(*population);	// sort them

            mate(*population, *buffer, tsize);	// mate the population together
            swap(population, buffer);		// swap buffers
        }
        print_best(*population, tsize);
    }
    return 0;
}
