p5.out: maxfinder.o NetDriver.o
	g++ -Wall -ansi -g -o p5.out maxfinder.o NetDriver.o


maxfinder.o: maxfinder.cpp NetDriver.h maxfinder.h   
	g++ -Wall -ansi -g -c maxfinder.cpp

NetDriver.o: NetDriver.cpp CPUTimer.h NetDriver.h maxfinder.h 
	g++ -Wall -ansi -g -c NetDriver.cpp

clean:
	rm -f p5.out maxfinder.o NetDriver.o
