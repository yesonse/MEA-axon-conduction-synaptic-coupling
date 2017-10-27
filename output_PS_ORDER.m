function output_PS_ORDER(file_name_ps,file_mat)
  load(file_mat)
  % add by Lin at 10_19_2017
  [SortedSpikes.chID] = SortedSpikes.ChannelID; SortedSpikes = orderfields(SortedSpikes,[1:0,8,1:7]); SortedSpikes = rmfield(SortedSpikes,'ChannelID');
  
  count =1;
  for ii = 1:size(SortedSpikes,2)
    for jj = 1:size(SortedSpikes(ii).chID,2)
      Nam{count} = SortedSpikes(ii).chID{1,jj};
      count = count+1;
    end
  end
  
[Z_ps,names_ps] = fullmatrixV2(file_name_ps); %function
setname = setdiff(Nam,names_ps);
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
    pdff{k} = strcat('tmp_',num2str(k),'.pdf');
    [r c] = find(MC(:,i));
    ps{i} = names_ps(1,r);
    name = names_ps(1,r);
    nameid = name;
    pss = [];
    for j = 1:length(r)
        pss(j,:) = Z_ps(r(j),r);
    end 
    bg1 = biograph(pss,name);
    get(bg1.nodes,'ID');
    bg1.showWeights='on';

    set(bg1,'NodeCallback')
    set(bg1,'EdgeCallback')
    set(bg1.nodes,'shape','circle','lineColor',[0,0,0]);

    set(bg1.nodes,'textColor',[0,0,0],'lineWidth',2,'fontsize',9);
    set(bg1,'arrowSize',12,'edgeFontSize',9);
    get(bg1.nodes,'position')


    g = biograph.bggui(bg1);

    f1 = get(g.biograph.hgAxes, 'Parent');                                                              
    print(f1,'-dpdf',pdff{k}(1:end-4),'-bestfit');
    k = k+1;

    for oi = 1:size(pss,2)
      nameid(2,oi) = num2cell(length(find(pss(:,oi)~=0)));
    end
    nameid = nameid';
    nameid = cell2table(nameid);
    nameid = sortrows(nameid,'nameid2','ascend');
    psid{i} = nameid.nameid1';
end

pdff
filename = strcat(file_name_ps(1:end-4),'.pdf');
append_pdfs(filename,pdff{:});
delete tmp*.pdf

psid = psid';

[nr,nc] = size(psid);
for i1 = 1:length(setname)
   psid{nr+i1,1}{1,1} = setname{i1};
end
file_ps = strcat(file_name_ps(1:end-4),'.dat');
fileID_ps = fopen(file_ps,'w');
  for row = 1:size(psid,1)
      fprintf(fileID_ps, '%d, ', row);
      fprintf(fileID_ps, '%s,', psid{row}{1:end-1});
      fprintf(fileID_ps, '%s\n', psid{row}{end});
  end
fclose(fileID_ps);

