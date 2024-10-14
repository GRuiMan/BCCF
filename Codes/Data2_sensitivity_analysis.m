clc;clear;
%计算pt=ch,反算出c,并与真实值相比较
uwnd_path='../Data/uwnd.10m.gauss.2020.nc';
vwnd_path='../Data/vwnd.10m.gauss.2020.nc';
uwnd=ncread(uwnd_path,"uwnd");
vwnd=ncread(vwnd_path,"vwnd");

excel_file = '../Data/namco_BC.xlsx';
BCdata = readtable(excel_file,"VariableNamingRule","preserve");
BCdata=table2array(BCdata(:,2));
BC=BCdata(~isnan(BCdata));
new_length = 881;
x_old = linspace(1, length(BC), length(BC));
x_new = linspace(1, length(BC), new_length);
BC = interp1(x_old, BC, x_new, 'linear');
BC_smooth= smoothdata(BC, 'gaussian', 50);

day1=days(datetime(2020,8,5)-datetime(2020,1,1))+1;
day2=days(datetime(2020,9,11)-datetime(2020,1,1))+1;


%% 先计算时间t纳木错处散度，lon=49,lat=32是纳木错位置
%中央差分方案
R=6371000;
fei=pi/6;deltafei=180/93*pi/180;
lambda=pi/2;deltalambda=360/191*pi/180;
deltaX=R*cos(fei)*deltalambda;
deltaY=R*deltafei;
uwnd_WE=uwnd(48:50,32,day1:day2);
vwnd_SN=vwnd(49,31:33,day1:day2);

ux=zeros(1,38);vy=zeros(1,38);div=zeros(1,38);
for i=1:38
    ux(i)=(uwnd_WE(3,1,i)-uwnd_WE(1,1,i))/(2*deltaX);
    vy(i)=(vwnd_SN(1,3,i)-vwnd_SN(1,1,i))/(2*deltaY);
    div(i)=ux(i)+vy(i);
end

%从38个数插值成881个数
timex=linspace(1,38,881);
div=interp1(div,timex,'makima');

% 再计算时间t纳木错处雨强极限值，注意转换单位。
kgs2mmh=3600;
prate_path='../Data/prate.sfc.gauss.2020.nc';
prate=ncread(prate_path,"prate");
prate_namco=prate(49,32,day1:day2);
prate_namco=reshape(prate_namco,[1,38]);
prate_namco=prate_namco*kgs2mmh;

%从38个数插值成881个数
prate_namco=interp1(prate_namco,timex,'cubic');
prate_namco(prate_namco<0)=0;

%取deltat=1h,因为上面38天插值成了881h
deltat=1;A=0.51;B=0.78;
Lambda=A*prate_namco.^B;

%用简单梯形积分
Int=zeros(1,881);
for i=1:880
    Int(i)=(Lambda(i)+Lambda(i+1))/2;
end
Int(881)=Lambda(881);

%% 加载黑炭真实浓度和边界层高度，得到p(t)真实值/(2-exp(-Int(i)));
% 控制实验组
load ./Mat_Files/1_height_sim.mat
pt_real=height_sim.*BC_smooth;

t1=600;t2=0.5;
pt_control=zeros(1,881);
pt_control(1)=pt_real(1);
for i=1:880
    pt_control(i+1)=(pt_control(i)+t1*div(i)*pt_control(i))*1-(1-exp(-t2*Int(i)))*pt_control(i);
end
BC_control=pt_control./height_sim;
ctime1=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);
plot(ctime1,BC_smooth,'LineStyle','-','LineWidth',2.5)
hold on
plot(ctime1,BC_control,'LineStyle','-','LineWidth',2.5)
ylabel("Concentration/(ng/m^{-3})")
legend("Real","Simulated")
set(gca, 'FontName', 'Times New Roman')

%% 不考虑风力输送的模拟黑炭数据
% 实验组11
t1=0;t2=0.5;
pt_s11=zeros(1,881);
pt_s11(1)=pt_real(1);
for i=1:880
    pt_s11(i+1)=(pt_s11(i)+t1*div(i)*pt_s11(i))*1-(1-exp(-t2*Int(i)))*pt_s11(i);
end
BC_s11=pt_s11./height_sim;
ctime1=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);
text(datetime(2020,08,15), 20,"$$No\ Wind$$","Color",[0.00, 0.45, 0.74],"FontSize",12,Interpreter="latex")
hold on
plot(ctime1,BC_s11,'LineStyle','-','LineWidth',1.5)
ylabel("Concentration/(ng/m^{-3})")
set(gca, 'FontName', 'Times New Roman')


%% 不考虑降雨冲刷影响的模拟黑炭数据
% 实验组12
t1=600;t2=0;
pt_s12=zeros(1,881);
pt_s12(1)=pt_real(1);
for i=1:880
    pt_s12(i+1)=(pt_s12(i)+t1*div(i)*pt_s12(i))*1-(1-exp(-t2*Int(i)))*pt_s12(i);
end
BC_s12=pt_s12./height_sim;
ctime1=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);
text(datetime(2020,08,15), 300,"$$No\  Rainfall$$","Color",[0.00, 0.45, 0.74],"FontSize",12,Interpreter="latex")
hold on
plot(ctime1,BC_s12,'LineStyle','-','LineWidth',1.5)
ylabel("Concentration/(ng/m^{-3})")
set(gca, 'FontName', 'Times New Roman')


%% 当边界层高度是定值时，就假设是1000m
% 实验组13
BC_s13=pt_control/1000;
ylabel("Concentration/(ng/m^{-3})")
text(datetime(2020,08,15), 39,"$$Set\ PBL=1km$$","Color",[0.00, 0.45, 0.74],"FontSize",12,Interpreter='latex')
hold on
plot(ctime1,BC_s13,'LineStyle','-','LineWidth',1.5)
set(gca, 'FontName', 'Times New Roman')


%% 只受风力影响，降水为0，边界层不变化
% 实验组21
t1=600;t2=0;
pt_s21=zeros(1,881);
pt_s21(1)=pt_real(1);
for i=1:880
    pt_s21(i+1)=(pt_s21(i)+t1*div(i)*pt_s21(i))*1-(1-exp(-t2*Int(i)))*pt_s21(i);
end
BC_s21=pt_s21./1000;
ctime1=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);
hold on
plot(ctime1,BC_s21,'LineStyle','-','LineWidth',1.5)
ylabel("Concentration/(ng/m^{-3})")
set(gca, 'FontName', 'Times New Roman')


%% 只受降水影响，风力为0，边界层不变化
% 实验22
t1=0;t2=0.5;
pt_s22=zeros(1,881);
pt_s22(1)=pt_real(1);
for i=1:880
    pt_s22(i+1)=(pt_s22(i)+t1*div(i)*pt_s22(i))*1-(1-exp(-t2*Int(i)))*pt_s22(i);
end
BC_s22=pt_s22./1000;
ctime1=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);
text(datetime(2020,08,15), 20,"$$No\ Wind$$","Color",[0.00, 0.45, 0.74],"FontSize",12,Interpreter="latex")
hold on
plot(ctime1,BC_s22,'LineStyle','-','LineWidth',1.5)
ylabel("Concentration/(ng/m^{-3})")
set(gca, 'FontName', 'Times New Roman')


%% 只受边界层影响，降水，风力为0
%实验23
t1=0;t2=0;
pt_s23=zeros(1,881);
pt_s23(1)=pt_real(1);
for i=1:880
    pt_s23(i+1)=(pt_s23(i)+t1*div(i)*pt_s23(i))*1-(1-exp(-t2*Int(i)))*pt_s23(i);
end
BC_s23=pt_s23./height_sim;
ctime1=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);
text(datetime(2020,08,15), 20,"$$No\ Wind$$","Color",[0.00, 0.45, 0.74],"FontSize",12,Interpreter="latex")
hold on
plot(ctime1,BC_s23,'LineStyle','-','LineWidth',1.5)
ylabel("Concentration/(ng/m^{-3})")
set(gca, 'FontName', 'Times New Roman')


%% 保存为mat文件
save ./Mat_Files/BC_real.mat BC_smooth
save ./Mat_Files/BC_control.mat BC_control
save ./Mat_Files/BC_s11.mat BC_s11
save ./Mat_Files/BC_s12.mat BC_s12
save ./Mat_Files/BC_s13.mat BC_s13
save ./Mat_Files/BC_s21.mat BC_s21
save ./Mat_Files/BC_s22.mat BC_s22
save ./Mat_Files/BC_s23.mat BC_s23

