p4.out : defragmenter.o DefragRunner.o mynew.o  
	g++ -ansi -Wall -g -o p4.out defragmenter.o DefragRunner.o mynew.o  

defragmenter.o : defragmenter.cpp defragmenter.h 
	g++ -ansi -Wall -g -c defragmenter.cpp

DefragRunner.o : DefragRunner.cpp DefragRunner.h mynew.h CPUTimer.h defragmenter.h 
	g++ -ansi -Wall -g -c DefragRunner.cpp

mynew.o : mynew.cpp mynew.h 
	g++ -ansi -Wall -g -c mynew.cpp

clean : 
	rm -f p4.out defragmenter.o  DefragRunner.o  mynew.o   
