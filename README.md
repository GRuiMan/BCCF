# Codes&Data

## Codes

**Data1_height_sim_real.m**,Simulated boundary layer height,and produce simulated boundary layer height data,reanalysis boundary layer height.

**Data2_sensitivity_analysis.m**,sensitivity analysis,using 7 models,produce Mat data

**Data3_optimize_modify.m**，By optimizing the coefficients T1(t)T_1(t) and T2(t)T_2(t), the correlation coefficient between the simulated and observed black carbon concentrations is maximized. The optimized coefficients are denoted as T1_optimalT_{1\_optimal} and T2_optimalT_{2\_optimal}.

**Figure1_threeDMapDemo.m**,plot the Figure1

**Figures_simulated_sensitivity.ipynb**,plot the Figure2,3,4

**taylor.py**,function file,plot taylor figures

**Mat_Files**,save Mat files produced from **Data2_sensitivity_analysis.m,and Data3_optimize_modify.m，**

## Data

**PBL2020**, 2020 data on boundary layer heights in the Chinese region, with a time resolution of 3 hours.

**Pre2020**, data on rain intensity in Asia in 2020, with a temporal resolution of 1 day, from [National Tibetan Plateau Science Data Centre (tpdc.ac.cn)](https://data.tpdc.ac.cn/zh-hans/data/e45be858-bcb2-4fea-bd10-)

**namco_data.xlsx**, data measured by some instruments at Namucuo station, see the first sheet data description.

**namco_BC.xlsx**, data collated and saved separately from the 4th sheet in namco_data.xlsx. Black carbon concentration data from August to September 2020 at Namco station, with 1 hour time resolution.

**prate.sfc.gauss.2020.nc**, global surface precipitation rain intensity for 2020

**topo2deg.nc**, topographic data

**uwnd.10m.gauss.2020.nc**, 10-metre latitudinal winds for 2020

**vwnd.10m.gauss.2020.nc**, 10 metre meridional winds for 2020

Source URL: [NCEP-NCAR Reanalysis 1: NOAA Physical Sciences Laboratory NCEP-NCAR Reanalysis 1](https://psl.noaa.gov/data/gridded/data.ncep. reanalysis.html)

## Figures

Figure1_3D Topographic Map of China and Meteorological Factor Effects.png

Figure2_Seven Different Simulation Results.svg

Figure3_Ratios of Seven Different Simulation Results.svg

Figure4_Taylor Diagram of Seven Different Simulation Results.svg

# 代码和数据

## 代码

**Data1_height_sim_real.m**，对边界层进行模拟，输出模拟出的边界层高度数据1_height_sim.mat，以及再分析的边界层高度数据1_height_real.mat。

**Data2_sensitivity_analysis.m**，搭建模型进行敏感性分析，输出观测数据BC_real.mat，考虑所有因素模拟出的数据BC_control.mat，以及不同实验的输出BC_s11.mat,BC_s12.mat,BC_s13.mat,BC_s21.mat,BC_s22.mat,BC_s23.mat。

**Data3_optimize_modify.m**，通过优化系数$T_1(t),T_2(t)$，使得模拟得到的黑炭能够更好地和观测到的黑炭之间的相关系数达到最大。优化后的系数为T1_optimal,T2_optimal。

**Figure1_threeDMapDemo.m**，画图一示意图的。

**Figures_simulated_sensitivity.ipynb**，画图二观测与模拟图，图三观测与实验图，图四泰勒图

**taylor.py**，画泰勒图的函数

**Mat_Files**，保存了Data2_sensitivity_analysis.m进行数值试验的输出。和**Data3_optimize_modify.m**，算出来的T1_optimal,T2optimal。

## 数据

**PBL2020**，2020年中国地区边界层高度的数据，时间分辨率3小时

**Pre2020**，2020年亚洲地区雨强的数据，时间分辨率1天，来源网址：[国家青藏高原科学数据中心 (tpdc.ac.cn)](https://data.tpdc.ac.cn/zh-hans/data/e45be858-bcb2-4fea-bd10-5c2662cb34a5)

**namco_data.xlsx**，纳木错站的一些仪器所测数据，见第一个sheet数据说明。

**namco_BC.xlsx**，根据namco_data.xlsx中第4个sheet整理并另存的数据。纳木错站2020年8月至9月的黑炭浓度数据，时间分辨率1小时。

**prate.sfc.gauss.2020.nc**，2020年全球地表降水雨强

**topo2deg.nc**，地形数据

**uwnd.10m.gauss.2020.nc**，2020年10米纬向风

**vwnd.10m.gauss.2020.nc**，2020年10米经向风

来源网址：[NCEP-NCAR Reanalysis 1: NOAA Physical Sciences Laboratory NCEP-NCAR Reanalysis 1](https://psl.noaa.gov/data/gridded/data.ncep.reanalysis.html)

## 图片

Figure1_中国3d地形图与气象因子作用.png

Figure2_七种不同的模拟结果.svg

Figure3_七种不同的模拟结果比值.svg

Figure4_七种不同模拟结果泰勒图.svg
