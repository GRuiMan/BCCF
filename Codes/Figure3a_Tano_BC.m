clc;clear;

excel_file = '../Data/namco_BC.xlsx';
BCdata = readtable(excel_file,"VariableNamingRule","preserve");
BC=table2array(BCdata(:,2));
ctime1=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);


%% 气温变化
%月气温气候态
AIRmeandata='../Data/air.sig995.mon.ltm.1991-2020.nc';
AIRmean=ncread(AIRmeandata,"air");
AIR8mean=AIRmean(37,25,8);
AIR9mean=AIRmean(37,25,9);
AIR89mean=(AIR8mean+AIR9mean)/2;
AIR89mean=ones(1,881)*AIR89mean;

%% 月气温
AIRdata='../Data/air.sig995.2020.nc';
AIR=ncread(AIRdata,'air');
day1=days(datetime(2020,8,5)-datetime(2020,1,1))+1;
day2=days(datetime(2020,9,11)-datetime(2020,1,1))+1;
AIR=AIR(37,25,day1:day2)-273.15;
AIR=reshape(AIR,[38,1]);
deltax=linspace(1,38,881);
AIR=interp1(AIR,deltax,'makima');
%% 
yyaxis left
BC2 = smoothdata(BC, 'movmean', 50);
bar(ctime1,BC(1:881,:),0.2,'FaceAlpha', 0.4)
hold on
BC2=smoothdata(BC2(1:881,:),"gaussian",45);
plot(ctime1,BC2,LineWidth=2.0,LineStyle="-")
text(datetime(2020,08,22), 120, 'Aug 22', ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
xline(datetime(2020,08,22),'LineWidth', 2);
ylabel("Concentration/(ng/m^{-3})")


yyaxis right
Amean=smoothdata(AIR-AIR89mean,"gaussian",45);
plot(ctime1,Amean,'LineStyle','-.',LineWidth=1.5)
ylabel("Anomaly/(^\circC)")
legend("Black Carbon Concentration", ...
    "9-point smoothing " ,...
    "", ...
    "Daily Temperature Anomaly")
xlabel("time")

saveas(gcf,"./Figures/温度与黑炭浓度变化.svg")
