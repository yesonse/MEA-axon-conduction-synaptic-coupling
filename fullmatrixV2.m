function [Z,names] = fullmatrixV2(file_name)
% construct linkage matrix Z for signal conduction  
f = readtable(file_name);
  names = {};
  s = [];
  t = [];
  weights =[];

 for i = 1:size(f,1)                                                                         
    if f.PS_yes(i) == 0
        continue;
    end
    if f.PS_DeltaT(i) > 0
       k1 = cellstr(f.Neuron1(i));
       k2 = cellstr(f.Neuron2(i));
       K = [k1 k2];
       Lia = ~ismember(K,names);
       names = [names K(Lia)];
       weights = [weights f.PS_DeltaT(i)];
       for j = 1:length(names)
           if strcmp(k1,names(j))
              s = [s j];
           elseif strcmp(k2,names(j))
              t = [t j];
           end
       end
    elseif f.PS_DeltaT(i) < 0
       k1 = cellstr(f.Neuron2(i));
       k2 = cellstr(f.Neuron1(i));
       K = [k1 k2];
       Lia = ~ismember(K,names);
       names = [names K(Lia)];
       weights = [weights -f.PS_DeltaT(i)];
       for j = 1:length(names)
           if strcmp(k1,names(j))
              s = [s j];
           elseif strcmp(k2,names(j))
              t = [t j];
           end
       end
    else
         f.PS_DeltaT(i) = 0.0001;
           k1 = cellstr(f.Neuron2(i));
           k2 = cellstr(f.Neuron1(i));
           K = [k1 k2];
           Lia = ~ismember(K,names);
           names = [names K(Lia)];
           weights = [weights f.PS_DeltaT(i)];
           for j = 1:length(names)
              if strcmp(k1,names(j))
                  s = [s j];
             elseif strcmp(k2,names(j))
                  t = [t j];
              end
           end
     end

 end
X = sparse(s,t,weights);
Y = full(X);
Z =zeros(length(names));
r1 = length(names) - size(Y,1);
r2 = length(names) - size(Y,2);
if ~ismember(length(names), s)
    Z(1:length(names)-r1,:) = Y;
elseif ~ismember(length(names), t)
    Z(:,1:length(names)-r2) = Y;
else
    Z = Y;
end


