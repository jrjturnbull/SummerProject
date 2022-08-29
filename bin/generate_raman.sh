#!/bin/bash

EXP_FILE="/home/jrjturnbull/SummerProject/PROJECT/exp"
if ! test -f "${EXP_FILE}/10Kd2_31.8gpa.dat"; then
    echo "WARNING: Experimental spectra not found at $EXP_FILE"
    echo "         Unable to overlay over computed spectra"
    EXP_FILE="NULL"
fi

input=1
if ! test -z $1; then
    FILE=${1}.phonon
    if ! test -f "$FILE"; then
        echo "$FILE does not exist"
        input=0
    else
        seed=$1
    fi
else
    input=0
fi
while [ $input -eq 0 ]; do
    read -p "Please enter the seed name: " seed
    FILE=${seed}.phonon
    if ! test -f "$FILE"; then
        echo "$FILE does not exist"
    else
        input=1
    fi
done

re='^[0-9]+([.][0-9]+)?$'
if ! test -z $2; then
    if ! [[ $2 =~ $re ]] ; then
        echo "Invalid pressure"
        input=0
    else
        pressure=$2
    fi
else
    input=0
fi
while [ $input -eq 0 ]; do
    read -p "Please enter the current pressure: " pressure
    if ! [[ $pressure =~ $re ]] ; then
        echo "Invalid input"
    else
        input=1
    fi
done

input=0
exp=0
if ! test "$EXP_FILE" == "NULL"; then
while [ $input -eq 0 ]; do
    echo "Please select an experimental spectrum to overlay:"
    echo "      0   No spectrum"
    echo "      1   31.80GPa"
    echo "      2   40.05GPa"
    echo "      3   48.10GPa"
    echo "      4   54.50GPa"
    echo "      5   58.51GPa"
    read exp
    case "$exp" in
    1)
    exp=31.8
    input=1
    ;;
    2)
    exp=40.05
    input=1
    ;;
    3)
    exp=48.1
    input=1
    ;;
    4)
    exp=54.5
    input=1
    ;;
    5)
    exp=58.51
    input=1
    ;;
    0)
    exp=0
    input=1
    ;;
    *)
    echo "Invalid input"
    echo
    esac
done
fi

################################################################

rm -rf raman
mkdir raman
#pretty cumbersome, better to use perl or awk
sed -n '/+\s\+[-0-9.]\{6,10\}\s*[-0-9.]\{6,10\}\s*[-0-9.]\{6,10\}\s*[-0-9.]\{6,10\}/,+2 p' $seed.castep > tensorsanddepratio.txt
sed -n 's/+\s\+[-0-9.]\{6,10\}\s\+[-0-9.]\{6,10\}\s\+[-0-9.]\{6,10\}\s\+\([0-9.]\{6,10\}\)\s\++/\1/p' tensorsanddepratio.txt > depratios.txt
#sed -n 's/+\s\+\([-0-9.]\{6,10\}\)\s\+\([-0-9.]\{6,10\}\)\s\+\([-0-9.]\{6,10\}\)\s\++/\1,\2,\3/p' tensorsanddepratio.txt > tensors.txt
sed -n 's/+\s\+\([-0-9.]\{6,10\}\)\s\+\([-0-9.]\{6,10\}\)\s\+\([-0-9.]\{6,10\}\)\s\+.*\s\++/\1,\2,\3/p' tensorsanddepratio.txt > tensors.txt
awk '/intensity active/{i++}i==2' $seed.castep | sed -n 's/^\s+\s\+\([0-9]\{1,2\}\)\s\+\([0-9.-]\{8,11\}\)\s\+[a-z]\s\+[0-9.-]\+\s\+[Y,N]\s\+[Y,N]\s\++/\1,\2/p' > frequencies.txt
mv *.txt raman

################################################################

cp ~/SummerProject/bin/smoothSpec.m raman
LN=`grep -cve '^\s*$' raman/tensors.txt`
LN=$((LN / 3))
if [ "$exp" == 0 ]; then
cat << E0F >> raman/CalcRaman.m
clear all
df = 0.5;
Fplot = 600;
dephasing = 100;
freq = 0:df:Fplot;
frequencies = load("frequencies.txt");
tensors = load("tensors.txt");

Spectra = figure('Position', get(0, 'Screensize') * 0.5);

for i = 1:$LN
  rawSpec_back(i,:) = [frequencies(i,2),sum(sum(abs(tensors([3*(i-1)+1:(3*i-1)],1:2))^2))];
end

for i = 1:$LN
  rawSpec_iso(i,:) = [frequencies(i,2),sum(sum(abs(tensors([3*(i-1)+1:(3*i)],:))^2))];
end

smtSpec_bac = smoothSpec(rawSpec_back,freq,df,dephasing,Fplot);

smtSpec_iso = smoothSpec(rawSpec_iso,freq,df,dephasing,Fplot);

plot(smtSpec_bac(:,1)./sqrt(2), smtSpec_bac(:,2)./(max(smtSpec_bac(:,2))), smtSpec_iso(:,1)./sqrt(2), smtSpec_iso(:,2)./(max(smtSpec_iso(:,2))), '--')

xlabel('freq. (cm^{-1})')
ylabel('Intesity (arb. units)')
Spacegroup = '$seed';
Pressure = ' $pressure GPa';
title(strcat(Spacegroup, ' : ', Pressure));
legend(strcat(Spacegroup, ' C||Z backscatter'), strcat(Spacegroup, ' Isotropic'))

%print(Spectra, strcat(Spacegroup, '_', Pressure, "Spectra.pdf"), '-dpdf','-r0')
%print(Spectra, '-dpdf','-r0')
%print(wfn, strcat("results/", num2str(Temp), "k/", cap), '-dpdf','-r0')

saveas(Spectra, 'spectra.png')
uiwait(Spectra); exit
E0F

else

cat << E0F >> raman/CalcRaman.m
clear all
df = 0.5;
Fplot = 600;
dephasing = 100;
freq = 0:df:Fplot;
frequencies = load("frequencies.txt");
tensors = load("tensors.txt");

Spectra = figure('Position', get(0, 'Screensize') * 0.5);

for i = 1:$LN
  rawSpec_back(i,:) = [frequencies(i,2),sum(sum(abs(tensors([3*(i-1)+1:(3*i-1)],1:2))^2))];
end

for i = 1:$LN
  rawSpec_iso(i,:) = [frequencies(i,2),sum(sum(abs(tensors([3*(i-1)+1:(3*i)],:))^2))];
end

smtSpec_bac = smoothSpec(rawSpec_back,freq,df,dephasing,Fplot);

smtSpec_iso = smoothSpec(rawSpec_iso,freq,df,dephasing,Fplot);

expdata = load("${EXP_FILE}/10Kd2_${exp}gpa.dat");

plot(smtSpec_bac(:,1)./sqrt(2), smtSpec_bac(:,2)./(max(smtSpec_bac(:,2))), smtSpec_iso(:,1)./sqrt(2), smtSpec_iso(:,2)./(max(smtSpec_iso(:,2))), '--', expdata(:,1), expdata(:,2)./(max(expdata(:,2))))

xlabel('freq. (cm^{-1})')
ylabel('Intesity (arb. units)')
Spacegroup = '$seed';
Pressure = ' $pressure GPa';
title(strcat(Spacegroup, ' : ', Pressure));
legend(strcat(Spacegroup, ' C||Z backscatter'), strcat(Spacegroup, ' Isotropic'), strcat(Spacegroup, ' ${exp}GPa (experimental)'))

%print(Spectra, strcat(Spacegroup, '_', Pressure, "Spectra.pdf"), '-dpdf','-r0')
%print(Spectra, '-dpdf','-r0')
%print(wfn, strcat("results/", num2str(Temp), "k/", cap), '-dpdf','-r0')

saveas(Spectra, 'spectra.png')
uiwait(Spectra); exit
E0F

fi

echo '================================================================'
echo "Running Matlab script..."
cd raman
matlab -nosplash -nodesktop -r "run('CalcRaman.m');" | tail -n +11
echo "Spectrum saved to raman/spectra.png..."