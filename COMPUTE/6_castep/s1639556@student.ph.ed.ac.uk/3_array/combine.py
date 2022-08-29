#!/usr/bin/env python3
 
"""
Combines results from each array job task
"""
 
import sys
 
total_success_count = 0
total_samples = 0
for line in sys.stdin:
    _, success_count, num_samples = line.split()
    total_success_count += int(success_count)
    total_samples += int(num_samples)
 
# Calculate and output final estimate
pi_estimate = 4.0 * total_success_count / total_samples
result = '{} {} {}'.format(pi_estimate, total_success_count, total_samples)
print(result)
