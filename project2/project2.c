#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>

unsigned long long int fibonacci(unsigned long long int num){
    
    if(num < 0){
        return -1;
    }
    else if(num ==0){
        return 0;
    }
    // the initial sequence starts with 1,1
    int fib1=1, fib2=1, fib3=0;
    
    int count=2;
	
	// generate the fibonacci number
    while(num > count){
        fib3 = fib1+fib2;
        count++;
        fib1=fib2;
        fib2=fib3;
    }
    return fib3;
    
}

int main(void)
{
    int num_processes;
    printf("please enter an integer from 0 to 10: ");
    scanf ("%d",&num_processes);
    
	// create the process ids based on user input
    pid_t process_id[num_processes];
    
    for(int i=0;i<num_processes;i++){
        
		// creation fails if PID is less than 0
        if((process_id[i]=fork()) < 0){
            perror("ERROR Message: creation fails");
            abort();
        }
        
        else if(process_id[i] == 0){
            // child processes are created if PID equals 0
            // each child process has its PID
			// print out PID and the fibonacci numbers
            pid_t current_pid = getpid();
			printf("my id: %d\n", current_pid);
			
			int fib = current_pid %20;
			int result = fibonacci(fib);
			printf("my Fibonacci modulo 20: %"PRIu64"\n", result);
			
            exit(0);
        }
    }
    // Wait for all children processes to finish
    	pid_t id; 
    	int reference; // Reference parameter for wait
    	while(num_processes > 0) {
    		id = wait(&reference);
    		--num_processes;
    	}
    
    printf("all child processes are now done!!");
    
    return 0;
}
