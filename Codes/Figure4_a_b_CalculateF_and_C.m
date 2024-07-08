clc;clear;
%计算f=ch,反算出c,并与真实值相比较
uwnd_path='../Data/uwnd.10m.gauss.2020.nc';
vwnd_path='../Data/vwnd.10m.gauss.2020.nc';
uwnd=ncread(uwnd_path,"uwnd");
vwnd=ncread(vwnd_path,"vwnd");
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



%% 再计算时间t纳木错处雨强极限值，注意转换单位。
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

%% 加载黑炭真实浓度和边界层高度，得到f(t)真实值/(2-exp(-Int(i)));
load ../Data/Mat_Files/Boundary_layer_height_cal.mat
load ../Data/Mat_Files/BC_REAL.mat
real_ft=modiBl_height2.*BC2';

k1=570;k2=0.45;
ft=zeros(1,881);
ft(1)=real_ft(1);
for i=1:880
    ft(i+1)=(ft(i)+k1*div(i)*ft(i))*1-(1-exp(-k2*Int(i)))*ft(i);
end
ct1=ft./modiBl_height2;
ctime1=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);
plot(ctime1,BC2,'LineStyle','-','LineWidth',2.5)
hold on

% ct1=smoothdata(ct1, "gaussian", 50);
hold on
plot(ctime1,ct1,'LineStyle','-','LineWidth',2.5)

ylabel("Concentration/(ng/m^{-3})")
legend("Real","Simulated")
box off
set(gca, 'FontName', 'Times New Roman')
saveas(gcf,"../../Figures/Figure4_a_真实黑炭数据与模拟黑炭数据.svg")
%print('真实黑炭数据与模拟黑炭数据.png', '-dpng', '-r300')

%% 当边界层高度是定值时，就假设是1000m
ct12=ft/1000;
ylabel("Concentration/(ng/m^{-3})")
text(datetime(2020,08,15), 39,"$$Set\ PBL=1km$$","Color",[0.00, 0.45, 0.74],"FontSize",12,Interpreter='latex')
hold on
plot(ctime1,ct12,'LineStyle','-','LineWidth',1.5)
set(gca, 'FontName', 'Times New Roman')
% saveas(gcf,"排除边界层影响.svg")

%% 不考虑降雨冲刷影响的模拟黑炭数据
k1=570;k2=0;
ft2=zeros(1,881);
ft2(1)=real_ft(1);
for i=1:880
    ft2(i+1)=(ft2(i)+k1*div(i)*ft2(i))*1-(1-exp(-k2*Int(i)))*ft2(i);
end
ct2=ft2./modiBl_height2;
ctime1=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);
text(datetime(2020,08,15), 300,"$$No\  Rainfall$$","Color",[0.00, 0.45, 0.74],"FontSize",12,Interpreter="latex")
hold on
plot(ctime1,ct2,'LineStyle','-','LineWidth',1.5)
set(gca, 'FontName', 'Times New Roman')
ylabel("Concentration/(ng/m^{-3})")
% saveas(gcf,"排除降雨影响.svg")

%% 不考虑风力输送的模拟黑炭数据
k1=1;k2=0.45;
ft3=zeros(1,881);
ft3(1)=real_ft(1);
for i=1:880
    ft3(i+1)=(ft3(i)+k1*div(i)*ft3(i))*1-(1-exp(-k2*Int(i)))*ft3(i);
end
ct3=ft3./modiBl_height2;
ctime1=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);
text(datetime(2020,08,15), 20,"$$No\ Wind$$","Color",[0.00, 0.45, 0.74],"FontSize",12,Interpreter="latex")
hold on
plot(ctime1,ct3,'LineStyle','-','LineWidth',1.5)
set(gca, 'FontName', 'Times New Roman')
ylabel("Concentration/(ng/m^{-3})")
% saveas(gcf,"排除风力输送影响.svg")

%% 比率
ratio1=ct1./BC2';%模拟的全部都考虑的
ratio12=ct12./BC2';%不考虑边界层
ratio2=ct2./BC2';%不考虑降水
ratio3=ct3./BC2';%不考虑风


choose=881;
plot(ctime1(1:choose),ratio1,'LineWidth',1.5)
hold on
plot(ctime1(1:choose),ratio12,'LineWidth',1.5)
hold on
plot(ctime1(1:choose),smoothdata(ratio2,'gaussian',130),'LineWidth',1.5,'Color',[0.4660 0.6740 0.1880])
hold on
plot(ctime1(1:choose),ratio3,'LineWidth',1.5)
hold on
% plot(ctime1,ones(1,881),'Color','k','LineWidth',1.)
ylabel("$Ratio:\frac{simulated}{real}$","Interpreter","latex")


legend("considering all factors", ...
    "excluding boundary layer height" , ...
    "excluding rainfall intensity", ...
        "excluding wind transport", ...
    'Location', 'northwest')
set(gca, 'FontName', 'Times New Roman')
box off 
saveas(gcf,"../../Figures/Figure4_b_对不同因素考虑与排除.svg")



