// a fast genetic algorithm for the 0-1 knapsack problem
// by karoly zsolnai - keeroy@cs.bme.hu
// test case: 1000 items, 50 knapsack size
//
// compilation by: g++ genetic.cpp -O3 -ffast-math -fopenmp
#include <math.h>
#include <time.h>
#include <algorithm>
#include <vector>
#include <fstream>
#include <limits.h>
#include <stdlib.h>

#if defined(__linux) || defined(__linux__)
	unsigned int seed = time(NULL);
	#define RND ((double)rand_r(&seed)/RAND_MAX) // reentrant uniform rnd
#endif

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__)
	#define RND ((double)rand()/RAND_MAX) // uniform rnd
#endif

using namespace std;

struct chromo {
	chromo(int dimc) { items = new bool[dimc]; }
	~chromo() {	items = NULL; }
	void mutate(const int dimc, const int count) {
		int mi;
		for(int i=0;i<count;i++) {
			mi = (int)(round(RND*(dimc-1)));
			items[mi] = !items[mi];
		}
	}
	bool* items;
	int f;
};

int fitness(bool*& x, const int dimc, const vector<int>& v, const vector<int>& w, const int limit) {
	int fit = 0, wsum = 0;
	for(int i=0;i<dimc;i++) {
		wsum += x[i]*w[i];
		fit += x[i]*v[i];
	}
	if(wsum>limit) fit -= 7*(wsum-limit); // penalty for invalid solutions
	//if(wsum>limit) fit = 0; // penalty for invalid solutions
	return fit;
}

void crossover1p(const chromo& c1, const chromo& c2, const chromo& c3, const int dimc, const int cp) {
	for(int i=0;i<dimc;i++) {
		if(i<cp) { c3.items[i] = c1.items[i]; }
		else { c3.items[i] = c2.items[i]; }
	}
}

void crossover1p_b(const chromo &c1, const chromo &c2, const chromo &c3, int dimc, int cp) {
	for(int i=0;i<dimc;i++) {
		if(i>=cp) { c3.items[i] = c1.items[i]; }
		else { c3.items[i] = c2.items[i]; }
	}
}

void crossoverrand(const chromo &c1, const chromo &c2, const chromo &c3, const int dimc) {
	for(int i=0;i<dimc;i++) {
		if(round(RND)) { c3.items[i] = c1.items[i]; }
		else { c3.items[i] = c2.items[i]; }
	}
}

void crossoverarit(const chromo &c1, const chromo &c2, const chromo &c3, int dimc) {
	for(int i=0;i<dimc;i++) {
		c3.items[i] = (c1.items[i]^c2.items[i]);
	}
}

bool cfit(const chromo &c1,const chromo &c2) { return c1.f > c2.f; }
bool cmpfun(const std::pair<int,double> &r1, const std::pair<int,double> &r2) { return r1.second > r2.second; }

int coin(const double crp) { // a cointoss
	if(RND<crp) return 1; // crossover
	else return 0; // mutation
}

// initializes the chromosomes with the results of a greedy algorithm
void initpopg(bool**& c, const std::vector<int> &w, const std::vector<int> &v, const int dimw, const int limit, const int pop) {
	std::vector<std::pair<int,double> > rvals(dimw);
	std::vector<int> index(dimw,0);
	for(int i=0;i<dimw;i++) {
		rvals.push_back(std::pair<int,double>(std::make_pair(i,(double)v[i]/(double)w[i])));
	}
	std::sort(rvals.begin(),rvals.end(),cmpfun);
	int currentw = 0, k;
	for(int i=0;i<dimw;i++) {
		k = rvals[i].first;
		if(currentw + w[k] <= limit) { // greedy fill
			currentw += w[k];
			//printf("%d, %d\n", currentw, k);
			index[k] = 1;
		}
	}
	for(int i=0;i<pop;i++) {
		for(int j=0;j<dimw;j++) {
			c[i][j] = index[j];
		}
	}
}

void init(bool**& c, const int dimw, const int pop){
	for(int i=0;i<pop;i++) {
		for(int j=0;j<dimw;j++) {
			c[i][j] = rand()%2;
		}
	}
}

int main(int argc, char* argv[]) {
	printf("\n");
	srand(time(NULL));
	vector<int> w, v; // items weights and values
	int info=0, limit = 0, num = 0, i = 0;
	ifstream file(argv[1]);
	file >> num;
	file >> limit;	
	while(i < num) {
		file >> info;		
		v.push_back(info);		
		info=0;
		file >> info;
		w.push_back(info);
		i++;
	} // omitted fclose(f1) and fclose(f2) on purpose
	const int pop = 10000; // chromosome population size
	const int gens = 20000; // maximum number of generations
	const int disc = (int)(ceil(pop*0.60)); // chromosomes discarded via elitism
	const int dimw = w.size();
	int best = 0, ind = 0, ind2 = 0, times = 1, iterations_taken = 0; // a few helpers for the main()
	int parc = 0; // parent index for crossover
	double avg = 0, crp = 0.35; // crossover probability
	while(times > 0){
	// reinitialize helper variables
	best = 0, ind = 0, ind2 = 0, parc = 0, avg = 0;
	//
	vector<chromo> ch(pop,chromo(dimw));
	bool **c = new bool*[pop];
	for(int i=0;i<pop;i++) c[i] = new bool[dimw];
	clock_t start = clock();
	printf("Initializing population with a greedy algorithm..."); //randomly initialize the population
	initpopg(c,w,v,dimw,limit,pop);
	//init(c, dimw, pop);			
	printf("done!");

	for(int i=0;i<pop;i++) {
		ch[i].items = c[i];
		ch[i].f = fitness(ch[i].items, dimw ,v, w, limit);
	}
	printf("\n\n");
	
	for(int p=0;p<gens;p++) {
		std::sort(ch.begin(), ch.end(), cfit);
		#pragma omp parallel for shared(ch)
		for(int i=0;i<pop;i++) {
			if(i>pop-disc) { // elitism - only processes the discarded chromo
				if(coin(crp)==1) { // crossover sectionsomes
					ind = parc+round(10*RND); // choosing parents for crossover
					ind2 = parc+1+round(10*RND);
					// choose a crossover strategy here
					crossover1p(ch[ind%pop],ch[ind2%pop],ch[i],dimw,round(RND*(dimw-1)));
//					crossoverrand(ch[ind],ch[ind2],ch[i],dimw);
//					crossoverarit(ch[0],ch[1],ch[i],dimw);
					ch[i].f = fitness(ch[i].items, dimw ,v, w, limit);
					parc += 1;
				}
				else { // mutation section
					ch[i].mutate(dimw,1);
					ch[i].f = fitness(ch[i].items, dimw ,v, w, limit);
				}
			}
			avg += ch[i].f;
			if(ch[i].f>best) best=ch[i].f;
		}
		parc = 0;
		if(p%100==0) {
			printf("\n#%d\t",p);
			printf("best fitness: %d \t",best);
			printf("avg fitness: %f",avg/pop);
			/*if(best == 23974){
				iterations_taken += p;
				printf("iterations taken= %d \n", p);				
				goto end; // psst...don't tell anyone			
			}*/		
		}
		best = avg = 0;
	}

end:
	//printf("\n\n");
	clock_t end = clock();
	double t = (double)(end-start)/CLOCKS_PER_SEC;
	//printf("\nCompletion time: %fs.\n",t);
	printf("curr iteration = %d \n", times);
	times--;	
	free(c);
	}
	printf("total iterations taken = %d \n", iterations_taken);
	printf("average iterations taken = %d \n", iterations_taken/100);
	return 0;
}
