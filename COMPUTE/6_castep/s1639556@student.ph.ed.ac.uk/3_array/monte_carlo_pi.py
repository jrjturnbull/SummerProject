#!/usr/bin/env python3
 
"""
Estimates the value of Pi by Monte Carlo sampling.
"""
 
import itertools
import random
from argparse import ArgumentParser
 
# Read in command line arguments
parser = ArgumentParser(description=__doc__)
parser.add_argument('--output', '-o', help='Output to specified file instead of STDOUT')
parser.add_argument('num_samples', type=int, help='Number of samples')
args = parser.parse_args()
num_samples = args.num_samples
output_file_path = args.output
 
def do_monte_carlo(num_samples):
    """Runs MC simulation, sampling num_samples times"""
    success_count = 0
    for _ in itertools.repeat(None, num_samples):
        # Generate a point in the unit square bounded by (0,0) (0,1) (1,1) (1,0)
        (x, y) = (random.random(), random.random())
        # Determine if it lies in the circle of radius 1/2 centred at (1/2,1/2)
        if (x-0.5)**2 + (y-0.5)**2 < 0.25:
            success_count += 1
    return success_count
 
# Run Monte Carlo simulation
success_count = do_monte_carlo(num_samples)
 
# Calculate final estimate from:
# pi = Area of circle / r^2
# =~ (success_count / num_samples) / (1/2)^2
# = 4 * success_count / num_samples
pi_estimate = 4.0 * success_count / num_samples
 
# Output result
result = '{} {} {}'.format(pi_estimate, success_count, num_samples)
if output_file_path:
    with open(output_file_path, 'wt') as output_file:
        print(result, file=output_file)
else:
    print(result)
