function smtSpec = smoothSpec(rawSpec,freq,df,dephasing,Fplot);

  %dephasing = 2*dephasing;
  dim = size(rawSpec,2)-1;
  
  %bin spectrum
  binSpec = [];
  [N,idx]=histc(rawSpec(:,1),freq);
  for fr = 1:max(idx),
    intens = sum(rawSpec(idx==fr,2:end),1);
    binSpec = [binSpec; [freq(fr), intens]];
  end
  
  %smooth spectrum
  smtSpec(:,1) = binSpec(:,1);
  smtSpec(:,2:dim+1) = zeros(size(binSpec,1),dim);
  for fr = 1:max(idx),
    smtSpec(:,2:end) = smtSpec(:,2:end) + repmat(binSpec(fr,2:end),[max(idx),1,1]).*(dephasing/(4*pi^2))./((binSpec(:,1) - binSpec(fr,1)).^2 + (dephasing/(2*pi))^2);%Correct -- tested with Ioan 14/07
  end
  
  smtSpec = smtSpec(smtSpec(:,1) < Fplot & smtSpec(:,1) > 0,:);
  
end