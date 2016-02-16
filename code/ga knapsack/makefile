knap: main.o functions.o
	g++ -O3 -o knap main.o functions.o

main.o: main.cpp structures.h
	g++ -c -O3 main.cpp 

functions.o: functions.cpp structures.h
	g++ -c -O3 functions.cpp 

clean:
	rm -rf *.o
