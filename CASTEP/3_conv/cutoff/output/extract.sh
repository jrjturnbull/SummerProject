#!/bin/sh

energy=100

while [ $energy -lt 601 ]; do
sed -n 64p quartz.castep_2.$energy >> oxygen.output
sed -n 69p quartz.castep_2.$energy >> silicon.output
energy=$((energy+10))
done

awk '{ print $10 }' oxygen.output > oxygen.dat
awk '{ print $10 }' silicon.output > silicon.dat

rm *.output