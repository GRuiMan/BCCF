clc;clear;
%计算温度距平与黑炭浓度之间的相关系数
%画出密度散点图
excel_file = '../Data/namco_BC.xlsx';
BCdata = readtable(excel_file,"VariableNamingRule","preserve");
BC=table2array(BCdata(:,2));
ctime=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);


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
AIR=interp1(AIR,deltax,'linear');


%% 8月5号~8月22号显著性检验,
AIRano=AIR-AIR89mean;
day3=days(datetime(2020,8,22)-datetime(2020,8,5))+1;


AIRano_interval1=AIRano(1:day3*24);
BC_interval1=BC(1:day3*24);
AIRano_interval1(isnan(BC_interval1))=NaN;
AIRano_interval1=AIRano_interval1(~isnan(BC_interval1));
BC_interval1=BC_interval1(~isnan(BC_interval1));

% 8月22号~9.11最后显著性检验
AIRano_interval2=AIRano(day3*24:end);
BC_interval2=BC(day3*24:end);
AIRano_interval2(isnan(BC_interval2))=NaN;
AIRano_interval2=AIRano_interval2(~isnan(BC_interval2));
BC_interval2=BC_interval2(~isnan(BC_interval2));



%% 调用python画图
sns=py.importlib.import_module("seaborn"); 
plt=py.importlib.import_module("matplotlib.pyplot");
pd=py.importlib.import_module("pandas");

% 选择choose表示进行一定的滑动相关
% 因为有一定的滞后性，查看滞后性的相关性
% 温度距平超前，选择前面
% 黑炭浓度滞后，选择后面
choose=340;
AIRchoose=AIRano_interval1(1:choose);
BCchoose=BC_interval1(end-choose+1:end);
Tano_BC2 = pd.DataFrame(struct('AIRchoose', AIRchoose, 'BCchoose', BCchoose));
g2=sns.jointplot(x="AIRchoose", y="BCchoose", data=Tano_BC2, kind="reg");
plt.xlabel("Temperature Anomaly($°C$)",fontname='Times New Roman')
plt.ylabel("Black Carbon($\mu g/m^{-3}$)",fontname='Times New Roman')
plt.xticks(fontname='Times New Roman')
plt.yticks(fontname='Times New Roman')
corr_coef = corrcoef(AIRchoose, BCchoose);
r2 = corr_coef(1, 2);
p2 = 0.01;
text = sprintf("r = %.2f, p = %.2e",r2,p2);
plt.text(0.95, 0.95, text, ha='right', va='top', transform=g2.ax_joint.transAxes,fontname='Times New Roman')
plt.savefig("../../Figures/Figure2_b_第一时期温度距平与黑炭.svg")
plt.show()



%%
sns=py.importlib.import_module("seaborn"); 
plt=py.importlib.import_module("matplotlib.pyplot");
pd=py.importlib.import_module("pandas");

choose=400;
AIRchoose=AIRano_interval2(1:choose);
BCchoose=BC_interval2(end-choose+1:end);
Tano_BC2 = pd.DataFrame(struct('AIRchoose', AIRchoose, 'BCchoose', BCchoose));
g2=sns.jointplot(x="AIRchoose", y="BCchoose", data=Tano_BC2, kind="reg");
plt.xlabel("Temperature Anomaly($°C$)",fontname='Times New Roman')
plt.ylabel("Black Carbon($\mu g/m^{-3}$)",fontname='Times New Roman')
plt.xticks(fontname='Times New Roman')
plt.yticks(fontname='Times New Roman')
corr_coef = corrcoef(AIRchoose, BCchoose);
r2 = corr_coef(1, 2);
p2 = 0.01;
text = sprintf("r = %.2f, p = %.2e",r2,p2);
plt.text(0.95, 0.95, text, ha='right', va='top', transform=g2.ax_joint.transAxes,fontname='Times New Roman')
plt.savefig("../../Figures/Figure2_c_第二时期温度距平与黑炭.svg")
plt.show()








