clear all
dirc = strcat("C:/Users/peter/Edinburgh/Rotor/PhaseII/Results/Jamie/50GPa/Cmca-12/")
df = 0.5;
Fplot = 600;
dephasing = 100;
freq = 0:df:Fplot;
frequencies = load(strcat(dirc, "frequencies.txt"));
tensors = load(strcat(dirc, "tensors.txt"));

Spectra = figure()

for i = 1:size(frequencies)(1)
  rawSpec_back(i,:) = [frequencies(i,2),sum(sum(abs(tensors([3*(i-1)+1:(3*i-1)],1:2))^2))];
endfor

for i = 1:size(frequencies)(1)
  rawSpec_iso(i,:) = [frequencies(i,2),sum(sum(abs(tensors([3*(i-1)+1:(3*i)],:))^2))];
endfor


smtSpec_bac = smoothSpec(rawSpec_back,freq,df,dephasing,Fplot);

smtSpec_iso = smoothSpec(rawSpec_iso,freq,df,dephasing,Fplot);

expdata = load("C:/Users/peter/Edinburgh/Rotor/Results/MiriamData/RawSpectra/10Kd2_48.1gpa.dat");

plot(smtSpec_bac(:,1)./sqrt(2), smtSpec_bac(:,2)./(max(smtSpec_bac(:,2))), smtSpec_iso(:,1)./sqrt(2), smtSpec_iso(:,2)./(max(smtSpec_iso(:,2))), '--', expdata(:,1), expdata(:,2)./(max(expdata(:,2))))

xlabel('freq. (cm^{-1})')
ylabel('Intesity (arb. units)')
Spacegroup = 'Pca2_1';
Pressure = '300GPa';
title(strcat(Spacegroup, ' ', Pressure));
legend(strcat(Spacegroup, ' C||Z backscatter'), strcat(Spacegroup, ' Isotropic'))

#print(Spectra, strcat(Spacegroup, '_', Pressure, "Spectra.pdf"), '-dpdf','-r0')
##print(Spectra, '-dpdf','-r0')
##print(wfn, strcat("results/", num2str(Temp), "k/", cap), '-dpdf','-r0')
