function h = ps_well
 % construct well for PS and Synaptic Coupling
h = figure;
axis([0 13 0 13])
set(gca,'XTick',(0:1:13))
set(gca,'YTick',(0:1:13))
axis ij
set(gca,'XTickLabel',{'','A','B','C','D','E','F','G','H','J','K','L','M',''})
set(gca,'XAxisLocation','origin','YAxisLocation','origin','Box','off')
hold on;
 i = 1;
    for j = 4:9
        plot(i,j,'o','color','k','MarkerSize',10)
    end

hold on;
i = 2;
    for j = 3:10
        plot(i,j,'o','color','k','MarkerSize',10)
    end
    hold on;
 i = 3;
    for j= 2:11
        plot(i,j,'o','color','k','MarkerSize',10)
    end

    hold on;
    
    for i = 4:9
      for j = 1:12
        plot(i,j,'o','color','k','MarkerSize',10)
       end
    end
hold on;
i = 12;
    for j = 4:9
        plot(i,j,'o','color','k','MarkerSize',10)
    end

hold on;
i = 11;
    for j = 3:10
        plot(i,j,'o','color','k','MarkerSize',10)
    end
    hold on;
 i = 10;
    for j= 2:11
        plot(i,j,'o','color','k','MarkerSize',10)
    end
    
    
