#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>

#define SQUARE(x) (x)*(x)
#define RANDOM_STATE_SIZE 32

static double next_random(struct random_data *buf);
static long do_monte_carlo(long num_trials, struct random_data *buf);

int main(int argc, char **argv)
{
    long requested_trials;
    long num_trials_per_thread = 0;
    long num_trials_total = 0;
    long total_success_count = 0;
    double pi_estimate;

    // Reads in the number of requested trials (as a long) from the command line arguments
    if (argc != 2)
    {
        printf("Required argument: number of trials\n");
        return EXIT_FAILURE;
    }
    requested_trials = strtol(argv[1], NULL, 10);
    if (requested_trials <= 0)
    {
        printf("Number of trials must be a positive long integer\n");
        return EXIT_FAILURE;
    }

    // The following section runs in parallel across all threads
    // Variables marked 'shared' are shared, and all others are defaulted to private
    #pragma omp parallel shared(total_success_count, num_trials_per_thread, num_trials_total, requested_trials) default(none)
    {
        int thread_num;
        long thread_success_count;
        struct random_data buf = { NULL };
        char state_buf[RANDOM_STATE_SIZE];

        // The following section is executed exactly once
        #pragma omp single
        {
            int num_threads = omp_get_num_threads();
            num_trials_per_thread= (requested_trials + num_threads - 1) / num_threads;
            num_trials_total = num_trials_per_thread * num_threads;
        }

        // Gets the current thread number and seeds random_r appropriately
        thread_num = omp_get_thread_num();
        initstate_r(time(NULL) + thread_num, state_buf, sizeof(state_buf), &buf);

        // Runs do_monte_carlo and prints the result
        thread_success_count = do_monte_carlo(num_trials_per_thread, &buf);
        printf("Thread %d did %ld trials and got %ld successful samples\n",
                thread_num, num_trials_per_thread, thread_success_count);
        
        // This ensures that the following code's parallel executions do not overlap
        #pragma omp critical
        total_success_count += thread_success_count;
    }

    // Calculates pi after all paralle threads are completed
    pi_estimate = 4.0 * total_success_count / num_trials_total;
    printf("%f %ld %ld\n", pi_estimate, total_success_count, num_trials_total);
 
    return EXIT_SUCCESS;
}

double next_random(struct random_data *buf)
{
    int32_t rnd;
    random_r(buf, &rnd);
    return (double) rnd / RAND_MAX;
}

long do_monte_carlo(long num_trials, struct random_data *buf) {
    double x,y;
    long i, success_count = 0;
    for (i = num_trials; i > 0; i--) {
        x = next_random(buf);
        y = next_random(buf);
        if (SQUARE(x-0.5) + SQUARE(y-0.5) < 0.25) {
            ++success_count;
        }
    }
    return success_count;
}