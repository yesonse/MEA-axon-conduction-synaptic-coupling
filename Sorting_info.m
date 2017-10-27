function Sorting_info(input,output)

input = strcat(input,'/**/*.h5');
holder = dir(input); 
if exist(output,'dir')==7
else
    mkdir(output);
end
addpath(genpath('/home/luly/toolbox/wave_clus-testing'),'-end');
num_files = size(holder,1);
gen_batch = cell(num_files,3);

for f = 1:num_files 
    base_string = holder(f).name;
    base_string = base_string(1:end-3);
    gen_batch{f,1} = strcat(holder(f).folder,'/',holder(f).name);   
    gen_batch{f,2} = strcat(output,'/',base_string,'.mat');
    gen_batch{f,3} = holder(f).bytes;
end

for i = 1:size(gen_batch,1)

 if exist(gen_batch{i,2},'file')==2
      continue;
 end
%{
 if gen_batch{i,3} > 800000000
      disp('Wrong file:')
      gen_batch{i,1}
      continue;
 end
%}
file_name = gen_batch{i,1};
all_data = h5read(file_name,'/Data/Recording_0/AnalogStream/Stream_0/ChannelData'); 
info = h5read(file_name,'/Data/Recording_0/AnalogStream/Stream_0/InfoChannel'); 
count = 1;
SortedSpikes = struct;
conv = double(info.ConversionFactor(1)) * 10^(double(info.Exponent(1)) + 6);

data_len = size(all_data,1)
sr = double(1e6/info.Tick(1))
segments_sec = double(data_len/sr);
segments_length = double(segments_sec/60)

for channel = 1:size(all_data,2) 
    data = all_data(:,channel)'; 
    save('channel_data.mat','data','sr','segments_length')
  %  save('channel_data.mat','data')   
    Get_spikes('channel_data.mat'); 
    load('channel_data_spikes.mat');
    if size(index,2) > 30 
        Do_clustering('channel_data_spikes.mat','make_plots',false);
        load('times_channel_data.mat');
        neurons = max(cluster_class(:,1));
        times = cell(1,neurons);
          
      if neurons >= 1     
        for n = 1:neurons 
            
            if neurons >=2 
               SortedSpikes(count).chID{n} = strcat(info.Label{channel},'_',int2str(n));
            else
               SortedSpikes(count).chID{n} = info.Label{channel};
            end
            
            row = [];
            ss = [];
            [row,col] = find(cluster_class == n); 
        %    ss = spikes(row,:);
      	    ss = spikes(row,:) * conv;
            SortedSpikes(count).spikes{n} = ss;
            SortedSpikes(count).threshold{n} = threshold * conv;
            for wf = 1:size(SortedSpikes(count).spikes,2)    
              SortedSpikes(count).dV{1,wf} = diff(SortedSpikes(count).spikes{1,wf},1,2);
	    end
            times{1,n} = (cluster_class(:,1)==n).*cluster_class(:,2);
            times{1,n}(times{1,n} == 0) = [];
            SortedSpikes(count).time{n} = times{1,n};
            SortedSpikes(count).ISI{n} = diff(SortedSpikes(count).time{n});            
            train = zeros(1,length(data)/20);
            train(ceil(times{1,n})) = 1;
            SortedSpikes(count).SpikeTrains{n} = train;
            SortedSpikes(count).NumSpikes{n} = sum(train);
	    SortedSpikes(count).duration = segments_sec;
%	    count = count +1;
        end
      
        count = count +1;
      end
    end
    
end

 % Saves the neuron IDs, wave form, DeltaV, spike times 
save(gen_batch{i,2},'SortedSpikes')
%save(gen_batch{i,3},'par')
end
