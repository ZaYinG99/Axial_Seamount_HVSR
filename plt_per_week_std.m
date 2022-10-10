
clc;
clear;
file = fopen('date_lst_2017');
folder = {};
i = 1; 
while ~feof(file)
    temp = fgetl(file);
    folder{i} = temp;
    i = i +1;
end
fclose(file);
nfolder = i-1;

for ifolder = 1:nfolder

        filename = [folder{ifolder}];
        temp = load(filename);
        temp (1,2) = 0;
        hvsr{ifolder} = temp;

end
for ifolder  =1:nfolder
    datenum(ifolder) = str2num(folder{ifolder}(6:8));
    for i = 1:365
        if i == datenum(ifolder)
            H(:,i) = hvsr{1,ifolder}(:,2);
        end
    end
end

    
    

i = 0;
l = 1;
temp = zeros(16384,1);
j = 1;
f_temp = [];
am_temp =[];
stdevs = [];
fpeak = [];
while j < 365
    
    temp = temp+H(:,j);
    
    if H(50,j)>0
        i = i+1;
        [peaks, locs] = findpeaks(H(280:493,j));
        if isempty(locs) == 0
            f_peak = hvsr{1,1}(locs(1)+279,1);
            peak_am = peaks;
        end
        f_temp = [f_temp f_peak];
        am_temp = [am_temp peak_am];
    end
    if mod(j,7) == 0 
        Z(:,l) = temp./i;
        am_all(l) = mean(am_temp);
        temp = zeros(16384,1);
        stdev = std(f_temp);
        am_dev = std(am_temp);
        stdevs(l) = stdev;
        am_devs(l) = am_dev;
        f_temp =[];
        am_temp = []
        l = l+1;
        i = 0;
    end
    j = j+1;
end
nfolder = l-1;
ypeak1=zeros(nfolder,1);

zmax1=zeros(nfolder,1);
for j = 1:nfolder
    [peaks1,locs1] = findpeaks(Z(280:493,j));
    
    f(j,:) = str2num(folder{j}(6:8));
    if ~isnan(locs1)
        zmax1(j)=peaks1(1);
        ypeak1(j)=hvsr{1,1}(locs1(1)+279,1);
        
    else
        ypeak1(j) = NaN;
        zmax1(j) = NaN;
        Z(:,j) = NaN;
    end
end

date = {'2017/01','2017/03','2017/05','2017/07','2017/09','2017/11'};

gcf = figure();%'visible','off');


x = 1:1:52;
y = hvsr{1,1}(:,1);
subplot(2,1,1)
[X,Y] = meshgrid(x,y);
C = Z;
pcolor(X,Y,Z);
xlim([0 52.5])
ylim([0.4 0.8])
zlim([0 5]);
EdgeColor = 'none';
shading interp;
%c = colorbar;
colormap(white);
caxis([0.5 4])
%c.Label.String = 'HVSR';
hold on
set(gca,'Layer','Top')
set(gca,'TickDir','In')
set(gca,'XtickLabel',date)
set(gca,'Xtick',[1.3,10,18.7,27.4,36.2,44.9]);
set(gca,'FontSize',18,'Fontname', 'Times New Roman');
%set(c,'FontSize',15,'Fontname', 'Times New Roman');
set(gca,'Linewidth',1);
ax = gca;
ax.YAxis.TickLength = [0.02 0];
ax.YAxis.LineWidth = 1;
ax.XAxis.TickLength = [0.02 0];
ax.XAxis.LineWidth = 1;
ax.XAxis.MinorTick = 'on';
ax.XAxis.MinorTickValues = [5.7,14.4,23.1,31.8,40.5,49.2];
%line([17 17],[0 5],'linestyle','--','linewidth',1.5,'color',[1 0 0]);
%text(18,0.65,'2015/04/24 Eruption','FontSize',18,'color',[1 0 0],'Fontname', 'Times New Roman');
%text(10,0.78,'a AXCC1','FontSize',18,'color','black','Fontname', 'Times New Roman','FontWeight','bold');
hold on

mean_peak = nanmean(ypeak1(10:17));
line([0 52.5],[mean_peak mean_peak],'linestyle','--','linewidth',1.5,'color','black');
hold on
errorbar(x,ypeak1,stdevs,'.', 'MarkerSize',10,'linewidth',1,'CapSize',3,'color','black');
scatter(x,ypeak1,40,'MarkerEdgeColor','black','MarkerFaceColor',[0.12 0.56 1],'LineWidth',0.5);
%plot(drop_position,-drops,'o','color','b','MarkerSize',10,'MarkerFaceColor','b')
title('AXAS1 2017','FontSize',20)
%xlabel('Month','FontSize',20)
ylabel('H/V Peak Frequency(Hz)','FontSize',20)
subplot(2,1,2)
errorbar(x,am_all,am_devs,'.', 'MarkerSize',10,'linewidth',1,'CapSize',3,'color','black');
hold on
scatter(x,am_all,40,'MarkerEdgeColor','black','MarkerFaceColor',[0.12 0.56 1],'LineWidth',0.5);
hold on
am_mean_peak = mean(am_all(10:17));
line([0 52.5],[am_mean_peak am_mean_peak],'linestyle','--','linewidth',1.5,'color','black');
hold on
xlim([0 52.5])
ylim([1 4])
set(gca,'Layer','Top')
set(gca,'TickDir','In')
set(gca,'XtickLabel',date)
set(gca,'Xtick',[1.3, 10,18.7,27.4,36.2,44.9]);
set(gca,'FontSize',18,'Fontname', 'Times New Roman');
%set(c,'FontSize',15,'Fontname', 'Times New Roman');
set(gca,'Linewidth',1);
ax = gca;
ax.YAxis.TickLength = [0.02 0];
ax.YAxis.LineWidth = 1;
ax.XAxis.TickLength = [0.02 0];
ax.XAxis.LineWidth = 1;
ax.XAxis.MinorTick = 'on';
ax.XAxis.MinorTickValues = [5.7,14.4,23.1,31.8,40.5,49.2];
%line([17 17],[0 5],'linestyle','--','linewidth',1.5,'color',[1 0 0]);
xlabel('Month','FontSize',20)
ylabel('H/V Amplitude','FontSize',20)

