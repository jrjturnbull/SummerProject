#!/bin/sh

energy=100

while [ $energy -lt 701 ]; do
sed -n 101p Si.castep_2.$energy >> Si.output
energy=$((energy+10))
done

awk '{ print $10 }' Si.output > Si.dat
rm *.output