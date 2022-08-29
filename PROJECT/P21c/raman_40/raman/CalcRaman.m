clear all
df = 0.5;
Fplot = 600;
dephasing = 100;
freq = 0:df:Fplot;
frequencies = load("frequencies.txt");
tensors = load("tensors.txt");

Spectra = figure('Position', get(0, 'Screensize') * 0.5);

for i = 1:72
  rawSpec_back(i,:) = [frequencies(i,2),sum(sum(abs(tensors([3*(i-1)+1:(3*i-1)],1:2))^2))];
end

for i = 1:72
  rawSpec_iso(i,:) = [frequencies(i,2),sum(sum(abs(tensors([3*(i-1)+1:(3*i)],:))^2))];
end

smtSpec_bac = smoothSpec(rawSpec_back,freq,df,dephasing,Fplot);

smtSpec_iso = smoothSpec(rawSpec_iso,freq,df,dephasing,Fplot);

expdata = load("/home/jrjturnbull/SummerProject/PROJECT/exp/10Kd2_40.05gpa.dat");

plot(smtSpec_bac(:,1)./sqrt(2), smtSpec_bac(:,2)./(max(smtSpec_bac(:,2))), smtSpec_iso(:,1)./sqrt(2), smtSpec_iso(:,2)./(max(smtSpec_iso(:,2))), '--', expdata(:,1), expdata(:,2)./(max(expdata(:,2))))

xlabel('freq. (cm^{-1})')
ylabel('Intesity (arb. units)')
Spacegroup = 'P21c';
Pressure = ' 40 GPa';
title(strcat(Spacegroup, ' : ', Pressure));
legend(strcat(Spacegroup, ' C||Z backscatter'), strcat(Spacegroup, ' Isotropic'), strcat(Spacegroup, ' 40.05GPa (experimental)'))

%print(Spectra, strcat(Spacegroup, '_', Pressure, "Spectra.pdf"), '-dpdf','-r0')
%print(Spectra, '-dpdf','-r0')
%print(wfn, strcat("results/", num2str(Temp), "k/", cap), '-dpdf','-r0')

saveas(Spectra, 'spectra.png')
uiwait(Spectra); exit
