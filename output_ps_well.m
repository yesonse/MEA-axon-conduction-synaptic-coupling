function psid = output_ps_well(file_name_ps,file_mat)
  load(file_mat)
  [SortedSpikes.chID] = SortedSpikes.ChannelID; SortedSpikes = orderfields(SortedSpikes,[1:0,8,1:7]); SortedSpikes = rmfield(SortedSpikes,'ChannelID');
  count =1;
  for ii = 1:size(SortedSpikes,2)
    for jj = 1:size(SortedSpikes(ii).chID,2)
      Nam{count} = SortedSpikes(ii).chID{1,jj};
      count = count+1;
    end
  end
  
[Z_ps,names] = fullmatrixV2(file_name_ps); %function
setname = setdiff(Nam,names);
A = Z_ps;
[m,n] = size(A);
for i = 1:m
      for j= 1:n
        if A(i,j) ~= 0
            A(i,j) = 1;
            A(j,i) = 1;
        end
      end
end
[ MC ] = maximalCliques(A); %function
ps = {};
psid = {};
k = 1;
for i = 1:size(MC,2)
    [r c] = find(MC(:,i));
    ps{i} = names(1,r);
    name = names(1,r);
    nameid = name;
    pss = [];
    for j = 1:length(r)
        pss(j,:) = Z_ps(r(j),r);
    end  
    for oi = 1:size(pss,2)
      nameid(2,oi) = num2cell(length(find(pss(:,oi)~=0)));
    end
    nameid = nameid';
    nameid = cell2table(nameid);
    nameid = sortrows(nameid,'nameid2','ascend');
    psid{i} = nameid.nameid1';
end
psid = psid';

[nr,nc] = size(psid);
for i1 = 1:length(setname)
   psid{nr+i1,1}{1,1} = setname{i1};
end

file_ps = strcat(file_name_ps(1:end-4),'_well.dat');
fileID_ps = fopen(file_ps,'w');
  for row = 1:size(psid,1)
      fprintf(fileID_ps, '%d, ', row);
      fprintf(fileID_ps, '%s,', psid{row}{1:end-1});
      fprintf(fileID_ps, '%s\n', psid{row}{end});
  end
  fclose(fileID_ps);
size(psid)
  
pdffile = strcat(file_name_ps(1:end-4),'_well.pdf');
for i = 1:size(psid,1)
    psid{i}
    h = ps_well;
    hold on;
    xalph = double(psid{i}{1,1}(1));
    if xalph > 73
        p(1) = xalph-65;
    else
        p(1) = xalph-64;
    end
    
    if length(psid{i}{1,1}) >= 4
        id = strfind(psid{i}{1,1},'_');
        id = id-1;
        p(2) = str2double(psid{i}{1,1}(2:id));
    else
        p(2) = str2double(psid{i}{1,1}(2:end));
    end
    plot(p(1),p(2),'o','color','r','MarkerFaceColor','r','MarkerSize',10);

    if length(psid{i}) > 1  
      hold on;    
      for j = 2:length(psid{i})
        xalph = double(psid{i}{1,j}(1));
        if xalph > 73
            p(1) = xalph - 65;
        else
            p(1) = xalph - 64;
        end
        
        if length(psid{i}{1,j}) >= 4
           id = strfind(psid{i}{1,j},'_');
           id = id-1;
           p(2) = str2double(psid{i}{1,j}(2:id));            
        else
           p(2) = str2double(psid{i}{1,j}(2:end));
        end
        plot(p(1),p(2),'o','color','k','MarkerFaceColor','k','MarkerSize',10);
        hold on;
      end
    end
    hold off;  
    pdff{i} = strcat('tmp_',num2str(i),'.pdf');
    print(pdff{i}(1:end-4),'-dpdf','-bestfit');
end
append_pdfs(pdffile,pdff{:});
delete tmp*.pdf;
