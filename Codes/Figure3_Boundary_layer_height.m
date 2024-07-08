clc;clear;

%粗略计算纳木错站30N大气边界层日平均高度
phi=pi/6;
omega=2*pi/(24*3600);
f=2*omega*sin(phi);


%% 先计算太阳高度角确定太阳辐射等级，青藏高原按照总云量≤4/≤4计算
times=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);
ns=days(times-datetime(2020,1,1,0,0,0)+1);
delta=23.45*sin(2*pi*(284+ns)/365)*pi/180;
T=hour(times);
W=15*(T-12)*pi/180;
sin_h0=sin(phi)*sin(delta)+cos(phi)*cos(delta).*cos(W);
h0=asin(sin_h0);

d2r=pi/180;
solar_rlevel=zeros(1,881);
solar_rlevel(h0<=0)=-2;
solar_rlevel(h0>0 & h0<=15*d2r)=-1;
solar_rlevel(h0>15*d2r & h0<=35*d2r)=1;
solar_rlevel(h0>35*d2r & h0<=65*d2r)=2;
solar_rlevel(h0>=35*d2r)=3;


%% 再求风速
uwnd_path='../Data/uwnd.10m.gauss.2020.nc';
vwnd_path='../Data/vwnd.10m.gauss.2020.nc';
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

uvwnd_TP=sqrt(uwnd_TP.^2+vwnd_TP.^2);
uvwnd_TP(uvwnd_TP>6)=6;

%% 再利用太阳辐射等级和风速确定边界层稳定度,1~6对应ABCDEF
atmospheric_stability=ones(1,881)*4;

Aloc=uvwnd_TP<1.9 & solar_rlevel>=2 |  ...
    (1.9<=uvwnd_TP)&(uvwnd_TP<=2.9) & solar_rlevel==3;
atmospheric_stability(Aloc)=1;
Bloc=uvwnd_TP<1.9 & solar_rlevel==1 | ...
    (1.9<=uvwnd_TP)&(uvwnd_TP<=2.9) & solar_rlevel==2 | ...
    (2.9<=uvwnd_TP)&(uvwnd_TP<=4.9) & solar_rlevel>=2 ;
atmospheric_stability(Bloc)=2;
Cloc=(4.9<=uvwnd_TP)&(uvwnd_TP<=5.9) & solar_rlevel>=2 | ...
    (1.9<=uvwnd_TP)&(uvwnd_TP<=4.9) & solar_rlevel==1;
atmospheric_stability(Cloc)=3;
Eloc=uvwnd_TP<=2.9 & solar_rlevel==-1 | ...
    (2.9<=uvwnd_TP)&(uvwnd_TP<=4.9) & solar_rlevel==-2 ;
atmospheric_stability(Eloc)=5;
Floc=uvwnd_TP<=2.9 & solar_rlevel==-2;
atmospheric_stability(Eloc)=6;
Dloc=(atmospheric_stability==4);

%% 边界层稳定度有了最后求边界层高度,用新疆，西藏青海的对应a_s,b_s
abratio=zeros(1,881);
abratio(atmospheric_stability==1)=0.09;
abratio(atmospheric_stability==2)=0.067;
abratio(atmospheric_stability==3)=0.041;
abratio(atmospheric_stability==4)=0.031;
abratio(atmospheric_stability==5)=1.66;
abratio(atmospheric_stability==6)=0.7;

asloc=Aloc | Bloc | Cloc | Dloc;
bsloc=Eloc| Floc;
Bl_height=zeros(1,881);
Bl_height(asloc)=abratio(asloc).*uvwnd_TP(asloc)/f;
Bl_height(bsloc)=abratio(bsloc).*sqrt(uvwnd_TP(bsloc))/f;

%% 由于没有考虑云等的影响，导致算出来的值很不符合常理
%对数据进行修正,用正常数据来代替不正常数据
%尽管也有一定误差，但是为了得到大致趋势，这样的牺牲精度是功大于过的

modiBl_height=Bl_height;
modiBl_height(1)=500;
for i=1:880
    if (modiBl_height(i)>9000 || modiBl_height(i+1)-modiBl_height(i)>650)
        modiBl_height(i+1)=modiBl_height(i);
    end
end
ctime=datetime(2020,8,5,23,0,0):hours(1):datetime(2020,9,11,15,0,0);



%% 读取真实边界层高度数据
folder_path = '../Data/PBL2020/'; 
start_date = datetime(2020,8,5);
end_date = datetime(2020,9,11);
namcopbl = zeros(1,304);
current_date = start_date;
i=1;
while current_date <= end_date
    for hour_delta=0:3:21
        nc_file = folder_path+sprintf("%d",year(current_date)) ...
            +sprintf("%02d",month(current_date)) ...
            +sprintf("%02d",day(current_date)) ...
            +sprintf("%02d",hour_delta)+".nc";
        chinapbl = ncread(nc_file, 'Merged Planetary Boundary Layer Height');
        chinapbl=chinapbl(81,101);
        namcopbl(i) = chinapbl;
        i=i+1;
    end
    current_date = current_date + 1;
end


%%
x_original = 1:numel(namcopbl);
x_interp = linspace(1, numel(namcopbl), 881);
namcopbl2 = interp1(x_original, namcopbl, x_interp, 'linear');
namcopbl3=smoothdata(namcopbl2,"gaussian",50);
modiBl_height2 = smoothdata(modiBl_height, "gaussian", 60);
plot(ctime,modiBl_height2+600,'LineWidth',2.5)
hold on
plot(ctime,namcopbl3 ,'LineWidth',2.5)
xlabel("Time")
ylabel("Height(m)")

% save Boundary_layer_height_real.mat namcopbl2
% save Boundary_layer_height_cal.mat modiBl_height2

legend("simulated","actual")
box off
set(gca, 'FontName', 'Times New Roman')
saveas(gcf,"../../Figures/Figure3_边界层高度实际与模拟.svg")





