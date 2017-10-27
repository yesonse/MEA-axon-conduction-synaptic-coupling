function  PS_hist_time(varargin)

  pvpmod(varargin);

  if ~exist('input', 'var')
    input = '.';
  end

  input = strcat(input,'/*.mat');

  holder = dir(input);
  num_files = size(holder,1);
  for f = 1:num_files    
    base_string = holder(f).name;
    base_string = base_string(1:end-4);
    csvfile = strcat(base_string,'_PS1.csv');
%{
    if exist(csvfile,'file')
      delete(csvfile);
      continue;
    end
%}    
    pdffile = strcat(base_string,'_PS1_hist.pdf');
%{
    if exist(pdffile,'file')
      delete(pdffile);
      continue;
    end
%}
    file_name = strcat(holder(f).folder,'/',holder(f).name)
    load(file_name);
    [SortedSpikes.time] = SortedSpikes.SpikeTimes; SortedSpikes = orderfields(SortedSpikes,[1:3,8,4:7]); SortedSpikes = rmfield(SortedSpikes,'SpikeTimes');
    [SortedSpikes.chID] = SortedSpikes.ChannelID; SortedSpikes = orderfields(SortedSpikes,[1:0,8,1:7]); SortedSpikes = rmfield(SortedSpikes,'ChannelID');
    
    Crosscorr = struct;
    
    k = 1;
    pdff = {};
      
    for i = 1:size(SortedSpikes,2)-1
     for j = i+1:size(SortedSpikes,2)
          for m1 = 1:size(SortedSpikes(i).time,2)
              if size(SortedSpikes(i).time{1,m1},1) < 30
                  continue;
              end

             for m2 = 1:size(SortedSpikes(j).time,2)
               if size(SortedSpikes(j).time{1,m2},1) < 30
                 continue;
               end
               xx1 = char(SortedSpikes(i).chID{1,m1});
               xx2 = char(SortedSpikes(j).chID{1,m2});
               if length(xx1) > 3
                 k1 = xx1(1:end-2);
                 neuron1 = xx1(end);
               else
                 k1 = xx1;
                 neuron1 = 0;
               end
               if length(xx2) > 3
                 k2 = xx2(1:end-2);
                 neuron2 = xx2(end);
               else
                 k2 = xx2;
                 neuron2 = 0;
               end
	       
               xalph1 = double(k1(1));
               xalph2 = double(k2(1));
               if xalph1 < 73
                 x1 = double(k1(1)-64);
               else
                 x1 = double(k1(1)-65);
               end
               if xalph2 < 73
                 x2 = double(k2(1)-64);
               else
                 x2 = double(k2(1)-65);
               end
               y1 = str2double(k1(2:length(k1)));
               y2 = str2double(k2(2:length(k2)));
               d.x = abs(x2-x1);
	       d.y = abs(y2-y1);
                       
               %ccc 
               n1 = length(SortedSpikes(i).time{1,m1});
               n2 = length(SortedSpikes(j).time{1,m2});
               nm = min(n1,n2);
               [Q0, deltaT] = CCC(SortedSpikes(i).time{1,m1},SortedSpikes(j).time{1,m2},1,100,180,0);
               [height,pos] = max(Q0);
	       pos = deltaT(pos);
               height = round(height);
               if isempty(Q0) | height < 80
		 clear Q0;
		 clear deltaT;
                 continue;
               end
	       [deltaT3,Q3,ic] = unique(deltaT);
	       Q3 = Q0(Q3);
	       
	       %SC
	       deltaT(deltaT >100 | deltaT <-100) = [];
	       [Q2,Qc] = hist(deltaT, -100:2:100);
	       [peak.value1,peak.position1] = max(Q2);
	       peak.value = peak.value1;
	       peak.position = peak.position1;
	       sc_t = Qc(peak.position);
	       if peak.value1 < 100
	       %          continue;
	       end

               deltaT1 = deltaT;
               deltaT1(deltaT1 <15 & deltaT1 > -15) = [];
               Q1 = hist(deltaT1, -100:2:100);
               if isempty(Q1)
                 clear deltaT;
                 continue;
               end
               peak.lambda = max(Q1);
               clear deltaT1;
               peak.probability = poisscdf((peak.value1-1),peak.lambda,'upper');
	       
	       SC_yes = 0;
	       common_input = 0;
	       
	       Q2(peak.position1) = 0;
	       [peak.value2,peak.position2] = max(Q2);
	       Q2(peak.position2) = 0;
	       [peak.value3,peak.position3] = max(Q2);
	       Q2(peak.position3) = 0;
	       [peak.value4,peak.position4] = max(Q2);
	       Q2(peak.position4) = 0;
	       
	       if peak.position > 1
		 Q2(peak.position-1) = 0;
	       end
	       if peak.position > 2
		 Q2(peak.position-2) = 0;
	       end
	       
	       if peak.position < length(Q2)
		 Q2(peak.position+1) = 0;
	       end
	       if peak.position < length(Q2) -1
		 Q2(peak.position+2) = 0;
	       end
	       
	       Q2 = sort(Q2,'descend');
	       if peak.value1 -60 > (Q2(1)+Q2(2)+Q2(3)+Q2(4)+Q2(5))/5
		 SC_yes = 1;
		 common_input = 1;
	       end
	       
	       if peak.value2 -30 > (Q2(1)+Q2(2)+Q2(3)+Q2(4)+Q2(5))/5
		 if abs(peak.position2 - peak.position1)>3
		   SC_yes = 0;
		   common_input = 0;
		 else
		   peak.value = peak.value + peak.value2;
		 end
	       end
	       
	       if peak.value3 -30 > (Q2(1)+Q2(2)+Q2(3)+Q2(4)+Q2(5))/5
		 if abs(peak.position3 - peak.position1)>3
		   SC_yes = 0;
		   common_input = 0;
		 else
		   peak.value = peak.value + peak.value3;
		 end
	       end
	       
	       sc_r = round(peak.value/nm,3);
	       
	       if abs (sc_t) < 2 | abs(pos) < 2
		 SC_yes = 0;
	       end
               if abs (sc_t) > 10 | abs(pos) > 10
                 SC_yes = 0;
		 common_input = 0;
               end
	       
	       if SC_yes > 0 
		 common_input = 0;
%		 continue;
	       else
%		 continue;
	       end
	       figure;
	       subplot(4,1,2);
	       hist(deltaT, -100:2:100);
	       title([num2str(SC_yes),' | ',num2str(peak.value1),' | ',num2str(sc_t)]);
	       
	       % PS
	       deltaT2 = deltaT;
	       deltaT2(deltaT >15 | deltaT < -15) = [];
	       deltaT(deltaT >2 | deltaT < -2) = [];
	       [ps1,psc] = hist(deltaT, -2:0.1:2);
	       [ps_event,PS_n] = max(ps1);
	       ps_event1 = ps_event;
	       ps_p = poisscdf((ps_event1-1),round(nm/41,0),'upper');
	       PS_deltaT = mode(deltaT);
	       if abs(PS_deltaT) > 1  % lin add at 10_17_2017
	 	 continue;
	       end
	       
	       PSyes = 0;
	       ps1(PS_n) = 0;
	       if PS_n > 1
		 ps_event = ps_event + ps1(PS_n-1);
		 ps1(PS_n-1) = 0;
	       end
	       if PS_n < length(ps1)
		 ps_event = ps_event + ps1(PS_n+1);
		 ps1(PS_n+1) = 0;
	       end
	       ps_r = round(ps_event/nm,3);
	       
	       ps1 = sort(ps1,'descend');
	       if ps_event1 -50 > (ps1(1)+ps1(2)+ps1(3)+ps1(4)+ps1(5))/5 & ps_event >= 100
		 PSyes = 1;
	       end
	       
	       if PSyes > 0
		 common_input = 0;
	       else
		 continue;
	       end
	       if common_input < 1
%		 continue;
	       end

	       %[pks,locs,wid,prom] = findpeaks(Q3,deltaT3,'SortStr','descend','MinPeakHeight',75,'MinPeakProminence',60,'MinPeakDistance',6);
	       subplot(4,1,1);
	       mdistanc =  max(deltaT3) - min(deltaT3) -0.05;
	       if mdistanc > 6
		 mdistanc = 6;
	       elseif mdistanc < 0
		 continue;
	       end
	       findpeaks(Q3,double(deltaT3),'MinPeakHeight',75,'MinPeakProminence',60,'MinPeakDistance',mdistanc,'Annotate','extents');
	       clear Q3;
	       clear Q0;
	       clear deltaT3;
	       title([num2str(common_input),' | ',num2str(height),'|',num2str(pos)]);
               subplot(4,1,3);
               hist(deltaT2, -15:1:15);
               clear deltaT2;
               title([k1,' - ',num2str(m1),'(',num2str(n1),') <-> ',k2,' - ',num2str(m2),'(',num2str(n2),') - ',num2str(peak.lambda),'|',num2str(peak.probability)]);
	       subplot(4,1,4);
	       hist(deltaT, -2:0.1:2);
	       clear deltaT;
	       title([k1,'(',num2str(n1),') <-> ',k2,'(',num2str(n2),')   -- ',num2str(PSyes),' | ',num2str(PS_deltaT),' | ',num2str(ps_event1)]);
	       
	       pdff{k} = strcat('tmp_',num2str(k),'.pdf');
	       print(pdff{k}(1:end-4),'-dpdf','-fillpage');
	       Crosscorr(k).id = k;
	       Crosscorr(k).File = base_string;
%              Crosscorr(k).Type = strtok(base_string(13:end),'_');
%              Crosscorr(k).Div = strtok(base_string(16:end),'_');
	       Crosscorr(k).chID1 = k1;
	       Crosscorr(k).chID2 = k2;
               Crosscorr(k).Neuron1 = SortedSpikes(i).chID{1,m1};
               Crosscorr(k).Neuron2 = SortedSpikes(j).chID{1,m2};
	       Crosscorr(k).Dist_x = d.x;
               Crosscorr(k).Dist_y = d.y;
	       Crosscorr(k).chID1_spikes = n1;
	       Crosscorr(k).chID2_spikes = n2;
	       %[h,p1] = kstest((norm_offsets)');
	       Crosscorr(k).PS_yes = PSyes;
	       Crosscorr(k).PS_event = ps_event;
	       Crosscorr(k).PS_DeltaT = PS_deltaT;
	       Crosscorr(k).PS_HZ = round((ps_event)/180,3);
	       Crosscorr(k).PS_others = sum(ps1);
	       Crosscorr(k).PS_Ratio = ps_r;
	       Crosscorr(k).PS_pvalue = ps_p;
	       Crosscorr(k).CI_yes = common_input;
	       Crosscorr(k).SC_yes = SC_yes;
	       Crosscorr(k).SC_event = peak.value;
	       Crosscorr(k).SC_DeltaT_bin = sc_t;
	       Crosscorr(k).SC_DeltaT_bin_height = peak.value1;
	       Crosscorr(k).SC_DeltaT_m = pos;
	       Crosscorr(k).SC_DeltaT_fq = height;
	       Crosscorr(k).SC_HZ = round((peak.value)/180,3);
	       Crosscorr(k).SC_Ratio = sc_r;   
               Crosscorr(k).lambda = peak.lambda;
               Crosscorr(k).probability = peak.probability;
 	       k = k+1;
	     end                   
	  end
     end
    end

    if k > 1  % or if size(Crosscorr,2) > 0 
      B = struct2table(Crosscorr);
      [B,ind] = sortrows(B, 'PS_event', 'descend');
      ID = zeros(size(B,1),1);
      ID(:,1) = 1:size(B,1);
      B.id=ID;
      writetable(B, csvfile);
      append_pdfs(pdffile,pdff{ind});
      delete tmp*.pdf;
      clear B;
    end
    clear Crosscorr;
    clear pdff;    
    
  end
end
