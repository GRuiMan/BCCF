clc;clear;
%计算温度距平与黑炭浓度之间的相关系数
%画出密度散点图
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
AIR=interp1(AIR,deltax,'linear');


%% 8月5号~8月22号显著性检验,用python画图
AIRano=AIR-AIR89mean;
day3=days(datetime(2020,8,19)-datetime(2020,8,5))+1;
AIRano1=AIRano(1:day3*24);
BC1=BC(1:day3*24);
a=isnan(BC1);
AIRano1(a)=NaN;
AIRano2=AIRano1(~a);
BC2=BC1(~a);


%%
sns=py.importlib.import_module("seaborn"); 
plt=py.importlib.import_module("matplotlib.pyplot");
pd=py.importlib.import_module("pandas");


choose=119;
AIRchoose=AIRano2(choose:end);
BCchoose=BC2(1:end-choose+1);
Tano_BC2 = pd.DataFrame(struct('AIRchoose', AIRchoose, 'BCchoose', BCchoose));
g2=sns.jointplot(x="AIRchoose", y="BCchoose", data=Tano_BC2, kind="reg");
plt.xlabel("Temperature Anomaly($°C$)",fontname='Times New Roman')
plt.ylabel("Black Carbon($\mu g/m^{-3}$)",fontname='Times New Roman')
corr_coef = corrcoef(AIRchoose, BCchoose);
r2 = corr_coef(1, 2);
p2 = 0.01;
text = sprintf("r = %.2f, p = %.2e",r2,p2);
plt.text(0.95, 0.95, text, ha='right', va='top', transform=g2.ax_joint.transAxes,fontname='Times New Roman')
plt.savefig("./Figures/第一时期温度距平与黑炭.svg")
plt.show()


%% 8月22号~最后显著性检验
AIRano3=AIRano(day3*24:end);
BC3=BC(day3*24:end);
a=isnan(BC3);
AIRano3(a)=NaN;
AIRano4=AIRano3(~a);
BC4=BC3(~a);




%%
sns=py.importlib.import_module("seaborn"); 
plt=py.importlib.import_module("matplotlib.pyplot");
pd=py.importlib.import_module("pandas");

choose=119;
AIRchoose=AIRano4(choose:end);
BCchoose=BC4(1:end-choose+1);
Tano_BC2 = pd.DataFrame(struct('AIRchoose', AIRchoose, 'BCchoose', BCchoose));
g2=sns.jointplot(x="AIRchoose", y="BCchoose", data=Tano_BC2, kind="reg");
plt.xlabel("Temperature Anomaly($°C$)",fontname='Times New Roman')
plt.ylabel("Black Carbon($\mu g/m^{-3}$)",fontname='Times New Roman')
corr_coef = corrcoef(AIRchoose, BCchoose);
r2 = corr_coef(1, 2);
p2 = 0.01;
text = sprintf("r = %.2f, p = %.2e",r2,p2);
plt.text(0.95, 0.95, text, ha='right', va='top', transform=g2.ax_joint.transAxes,fontname='Times New Roman')
plt.savefig("./Figures/第二时期温度距平与黑炭.svg")
plt.show()








