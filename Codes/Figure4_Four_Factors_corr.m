%风速，温度距平，雨强，黑炭浓度之间得热相关图
clc;clear;



%% 风速
uwnd_path='../NCEP-NCAR-Data/uwnd.10m.gauss.2020.nc';
vwnd_path='../NCEP-NCAR-Data/vwnd.10m.gauss.2020.nc';
uwnd=ncread(uwnd_path,'uwnd');
vwnd=ncread(vwnd_path,'vwnd');
day1=days(datetime(2020,8,5)-datetime(2020,1,1))+1;
day2=days(datetime(2020,9,11)-datetime(2020,1,1))+1;
uwnd_TP=uwnd(49,32,day1:day2);
vwnd_TP=vwnd(49,32,day1:day2);

deltax=linspace(1,38,881);
uwnd_TP=reshape(uwnd_TP,[38,1]);
uwnd_TP=interp1(uwnd_TP,deltax,'linear');
vwnd_TP=reshape(vwnd_TP,[38,1]);
vwnd_TP=interp1(vwnd_TP,deltax,'linear');
ctime1=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);
uvwnd_TP=sqrt(uwnd_TP.^2+vwnd_TP.^2);
uvwnd_TP2 = smoothdata(uvwnd_TP, "gaussian", 45);
plot(ctime1,uvwnd_TP2,LineWidth=1.5)
box off
ylabel("Wind Speed(m/s)")
saveas(gcf,"风速8月5到9月11.svg")

%再画8月20,8月27,9月3各自的图像风速和风向

%% 8月20号风速风向

ctime822=datetime(2020,8,18,0,0,0):hours(1):datetime(2020,8,26,0,0,0);
hour8221=hours(ctime822(1)-ctime1(1))+2;
hour8222=hours(ctime822(end)-ctime1(1))+2;
uwnd_TP822=uwnd_TP(hour8221:hour8222);
vwnd_TP822=vwnd_TP(hour8221:hour8222);
uvwnd_TP822=sqrt(uwnd_TP822.^2+vwnd_TP822.^2);
uvwnd_TP822 = smoothdata(uvwnd_TP822, "gaussian", 45);
plot(ctime822,uvwnd_TP822,LineWidth=1.5)
box off
ylabel("Wind Speed(m/s) and Wins Direction")
hold on

for i=0:8
    quiver(i,uvwnd_TP822(1+i*24),uwnd_TP822(1+i*24)/uvwnd_TP822(1+i*24),vwnd_TP822(1+i*24)/uvwnd_TP822(1+i*24), 'AutoScaleFactor', 0.5, 'Color', 'k', 'LineWidth', 2.5, 'MaxHeadSize', 2)

end


saveas(gcf,"风速风向8月18到8月26.svg")



%% 8月27号风速风向
ctime827=datetime(2020,8,23,0,0,0):hours(1):datetime(2020,8,31,0,0,0);
hour8271=hours(ctime827(1)-ctime1(1))+2;
hour8272=hours(ctime827(end)-ctime1(1))+2;
uwnd_TP827=uwnd_TP(hour8271:hour8272);
vwnd_TP827=vwnd_TP(hour8271:hour8272);
uvwnd_TP827=sqrt(uwnd_TP827.^2+vwnd_TP827.^2);
uvwnd_TP827 = smoothdata(uvwnd_TP827, "gaussian", 45);
plot(ctime827,uvwnd_TP827,LineWidth=1.5)
box off
ylabel("Wind Speed(m/s) and Wins Direction")
hold on

for i=0:8
    quiver(i,uvwnd_TP827(1+i*24),uwnd_TP827(1+i*24)/uvwnd_TP827(1+i*24),vwnd_TP827(1+i*24)/uvwnd_TP827(1+i*24), 'AutoScaleFactor', 0.5, 'Color', 'k', 'LineWidth', 2.5, 'MaxHeadSize', 2)

end

xline(datetime(2020,08,26),'LineWidth', 2);
xline(datetime(2020,08,28),'LineWidth', 2);
text(datetime(2020,08,26), 0.5, 'Aug 26th Light Rain', ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(datetime(2020,08,28), 0.5, 'Aug 28th Light Rain', ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
saveas(gcf,"风速风向8月23到8月31.svg")
%% 9月3号风速风向
ctime93=datetime(2020,8,30,0,0,0):hours(1):datetime(2020,9,7,0,0,0);
hour931=hours(ctime93(1)-ctime1(1))+2;
hour932=hours(ctime93(end)-ctime1(1))+2;
uwnd_TP93=uwnd_TP(hour931:hour932);
vwnd_TP93=vwnd_TP(hour931:hour932);
uvwnd_TP93=sqrt(uwnd_TP93.^2+vwnd_TP93.^2);
uvwnd_TP93 = smoothdata(uvwnd_TP93, "gaussian", 45);
plot(ctime93,uvwnd_TP93,LineWidth=1.5)
box off
ylabel("Wind Speed(m/s) and Wins Direction")
hold on
for i=0:8
    quiver(i,uvwnd_TP93(1+i*24),uwnd_TP93(1+i*24)/uvwnd_TP93(1+i*24),vwnd_TP93(1+i*24)/uvwnd_TP93(1+i*24), 'AutoScaleFactor', 0.5, 'Color', 'k', 'LineWidth', 2.5, 'MaxHeadSize', 2)

end

xline(datetime(2020,09,5),'LineWidth', 2);
xline(datetime(2020,09,6),'LineWidth', 2);
text(datetime(2020,9,5), 0.5, 'Sep 5th Rain', ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(datetime(2020,9,6), 0.5, 'Sep 6th Rain', ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
saveas(gcf,"风速风向8月30到9月7.svg")


%% 温度距平
%月气温气候态
AIRmeandata='../NCEP-NCAR-Data/air.sig995.mon.ltm.1991-2020.nc';
AIRmean=ncread(AIRmeandata,"air");
AIR8mean=AIRmean(37,25,8);
AIR9mean=AIRmean(37,25,9);
AIR89mean=(AIR8mean+AIR9mean)/2;
AIR89mean=ones(1,881)*AIR89mean;
%月气温
AIRdata='../NCEP-NCAR-Data/air.sig995.2020.nc';
AIR=ncread(AIRdata,'air');
day1=days(datetime(2020,8,5)-datetime(2020,1,1))+1;
day2=days(datetime(2020,9,11)-datetime(2020,1,1))+1;
AIR=AIR(37,25,day1:day2)-273.15;
AIR=reshape(AIR,[38,1]);
deltax=linspace(1,38,881);
AIR=interp1(AIR,deltax,'linear');
AIRano=AIR-AIR89mean;



%% 雨强
kgs2mmh=3600;
prate_path='../NCEP-NCAR-Data/prate.sfc.gauss.2020.nc';
prate=ncread(prate_path,"prate");
prate_namco=prate(49,32,day1:day2);
prate_namco=reshape(prate_namco,[1,38]);
prate_namco=prate_namco*kgs2mmh;

%从38个数插值成881个数
timex=linspace(1,38,881);
prate_namco=interp1(prate_namco,timex,'cubic');
prate_namco(prate_namco<0)=0;


%% 黑炭浓度
excel_file = '../BC_daily.xlsx';
BCdata = readtable(excel_file,"VariableNamingRule","preserve");
BC=table2array(BCdata(:,2));
BC2=smoothdata(BC,"gaussian",45);

%% 边界层高度
load Boundary_layer_height_real.mat
PBL=namcopbl2;


%%

% 计算四个数组之间的相关系数
corr_matrix = corrcoef([BC2, prate_namco', AIRano', uvwnd_TP',PBL']);
figure;
h=heatmap({'BC', 'Prate', 'Temp Ano', 'Wind Speed','PBL'}, ...
    {'BC', 'Prate', 'Temp Ano', 'Wind Speed','PBL'},  ...
    corr_matrix,'ColorbarVisible', 'on');
saveas(gcf,"五个因素之间相关.svg")
% title('Correlation Heatmap of BC2, prate_namco, AIRano, uvwnd_TP');


%% 计算t统计量

n=881;
corr_coef = corrcoef(PBL, BC2);
r2 = corr_coef(1, 2);
t=r2*sqrt(n-2)/sqrt(1-r2^2);
disp(t);
disp(r2);

