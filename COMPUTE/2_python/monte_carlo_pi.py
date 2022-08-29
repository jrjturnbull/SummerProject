#!/usr/bin/env python 3

import itertools
import random
from argparse import ArgumentParser

parser = ArgumentParser(description=__doc__)
parser.add_argument('--output', '-o', help='Output to specified file instead of STDOUT')
parser.add_argument('num_samples', type=int, help='Number of samples')
args = parser.parse_args()
num_samples = args.num_samples
output_file_path = args.output

def do_monte_carlo(num_samples):
    success_count = 0
    for _ in itertools.repeat(None, num_samples):
        (x, y) = (random.random(), random.random())
        if (x-0.5)**2 + (y-0.5)**2 < 0.25:
            success_count += 1
    return success_count

success_count = do_monte_carlo(num_samples)

pi_estimate = 4.0 * success_count / num_samples

result = '{} {} {}'.format(pi_estimate, success_count, num_samples)
if output_file_path:
    with open(output_file_path, 'wt') as output_file:
        print(result, file=output_file)
else:
    print(result)
