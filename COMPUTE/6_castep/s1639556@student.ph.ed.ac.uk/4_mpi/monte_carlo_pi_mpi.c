#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <mpi.h>

#define SQUARE(x) (x)*(x)

int world_size;
int world_rank;
long num_trials_per_process;
long num_trials_total;

double get_random()
{
    return (double) rand() / RAND_MAX;
}

long do_monte_carlo(long num_trials)
{
    double x, y;
    long i, success_count = 0;
    for (i = num_trials; i > 0; i--)
    {
        x = get_random();
        y = get_random();
        if (SQUARE(x-0.5) + SQUARE(y-0.5) < 0.25)
        {
            ++success_count;
        }
    }
    return success_count;
}

void merge_results_then_output(long master_success_count)
{
    long total_success_count = master_success_count;
    long count;
    int i;
    double pi_estimate;

    for (i = 1; i < world_size; i++)
    {
        MPI_Recv(&count, 1, MPI_LONG, MPI_ANY_SOURCE, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        total_success_count += count;
    }
    pi_estimate = 4.0 * total_success_count / num_trials_total;
    printf("%f %ld %ld\n", pi_estimate, total_success_count, num_trials_total);
}

int main(int argc, char **argv)
{
       MPI_Init(&argc, &argv);
       MPI_Comm_size(MPI_COMM_WORLD, &world_size);
       MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

       long requested_trials;
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

       num_trials_per_process = (requested_trials + world_size - 1) / world_size;
       num_trials_total = num_trials_per_process * world_size;

       srand(time(NULL) + world_rank);

       long success_count = do_monte_carlo(num_trials_per_process);

       if (world_rank == 0)
       {
           merge_results_then_output(success_count);
       }
       else
       {
           MPI_Send(&success_count, 1, MPI_LONG, 0, 0, MPI_COMM_WORLD);
       }

       MPI_Finalize();
       return EXIT_SUCCESS;
}