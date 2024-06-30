clc; clear
% Data0 = load('testData.mat');
% Data = Data0.Data(:,1:end);

BC_real=load('BC_REAL.mat');
BC_all=load('BC_ALL.mat');
BC_pbl=load('BC_PBL.mat');
BC_wind=load('BC_WIND.mat');
BC_rain=load('BC_RAIN.mat');
Data=[BC_real.BC2,BC_all.ct1',BC_pbl.ct12',BC_wind.ct3',BC_rain.ct2'];
Data=Data(:,1:3);


%%  Calculate STD RMSD and COR(计算标准差、中心均方根误差、相关系数)
STATS = zeros(4,size(Data,2));
for i = 1:size(Data,2)
    STATS(:,i) = SStats(Data(:,1),Data(:,i));
end
STATS(1,:) = [];

% Create taylor axes(生成泰勒图坐标区域)
figure('Units','normalized','Position',[.2,.1,.52,.72]);
TD = STaylorDiag(STATS);


% Color list(颜色列表)
colorList = [0.3569    0.0784    0.0784
    0.6784    0.4471    0.1725
    0.1020    0.3882    0.5176
    0.1725    0.4196    0.4392
    0.2824    0.2275    0.2902
    0.255     0.255     0.988];
% Plot(绘制散点图)
for i = 1:size(Data,2)
    TD.SPlot(STATS(1,i),STATS(2,i),STATS(3,i),'Marker','o','MarkerSize',15,...
        'Color',colorList(i,:),'MarkerFaceColor',colorList(i,:));
end

% Set other properties(设置其他属性)
TD.set('TickLength',[.015,.05])
TD.set('SLim',[0,30])
TD.set('RLim',[0,20])
TD.set('STickValues',0:6:30)
TD.set('SMinorTickValues',0:3:30)
TD.set('RTickValues',0:4:20)
TD.set('CTickValues',[.1,.2,.3,.4,.5,.6,.7,.8,.9,.95,.99])

% Set Grid(修饰各个网格)
TD.set('SGrid','Color',[.7,.7,.7],'LineWidth',1.2)
TD.set('RGrid','Color',[.77,.6,.18],'LineWidth',1.2)
TD.set('CGrid','Color',[0,0,.8],'LineStyle',':','LineWidth',.8);

% Set Tick Label(修饰刻度标签)
TD.set('STickLabelX','Color',[.8,0,0],'FontWeight','bold')
TD.set('STickLabelY','Color',[.8,0,0],'FontWeight','bold')
TD.set('RTickLabel','Color',[.77,.6,.18],'FontWeight','bold')
TD.set('CTickLabel','Color',[0,0,.8],'FontWeight','bold')

% Set Label(修饰标签)
TD.set('SLabel','Color',[.8,0,0],'FontWeight','bold')
TD.set('CLabel','Color',[0,0,.8],'FontWeight','bold')

% Set Axis(修饰各个轴)
TD.set('SAxis','Color',[.8,0,0],'LineWidth',2)
TD.set('CAxis','Color',[0,0,.8],'LineWidth',2)

% Set Tick and MinorTick(修饰主次刻度)
TD.set('STick','Color',[.8,0,0],'LineWidth',8)
TD.set('CTick','Color',[0,0,.8],'LineWidth',8)
TD.set('SMinorTick','Color',[.8,0,0],'LineWidth',5)
TD.set('CMinorTick','Color',[0,0,.8],'LineWidth',5)

% Legend
NameList = {'Real','Consider all','Boundary layer removal'};
% legend(NameList,'FontSize',8,'FontName','Times New Roman')

% Annotation
TD.SText(STATS(1,1),STATS(2,1),STATS(3,1),{'reference';' '},'FontWeight','bold',...
    'FontSize',15,'FontName','Times New Roman','Color',colorList(1,:),...
    'VerticalAlignment','bottom','HorizontalAlignment','center')

for i = 1:size(Data,2)
    TD.SText(STATS(1,i),STATS(2,i),STATS(3,i),"   "+string(NameList{i}),'FontWeight','bold',...
    'FontSize',10,'FontName','Times New Roman',...
    'VerticalAlignment','middle','HorizontalAlignment','left')
end

saveas(gcf,"泰勒图——对比考虑所有——去除边界层.svg")



