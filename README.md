# 代码以及数据

## 文件夹Codes

画的各张图像的代码，其中环境为MATLAB2023b+Python3.11开发环境以及相应的库，画图二的时候是在MATLAB中调用的Python3.11，可能会出现MATLAB崩溃的情形，按照提示修改即可。

## 文件夹Data

### 文件夹PBL2020:

2020年中国地区边界层数据，从2020年1月1日00时到2020年12月31日21时，时间分辨率为3小时。其中2020010100.nc为2020年1月1日00时的数据，依次类推。

来源网址：[全球逐三小时陆地高分辨率边界层高度数据集（2017-2021）- 时空三极环境大数据平台 (tpdc.ac.cn)](https://poles.tpdc.ac.cn/zh-hans/data/311e650c-4da1-4a8e-8d2d-91a268ceed78/?q=)

### 文件夹Pre2020

2020年中国区域(25$\sim$41°N,61$\sim$105°E)日平均降水率，从2020年1月1日到2020年12月31日，时间分辨率为1天。其中tpmfd_prcp_d_20200101.nc为2020年1月1日的数据，依次类推。

来源网址：[国家青藏高原科学数据中心 (tpdc.ac.cn)](https://data.tpdc.ac.cn/zh-hans/data/e45be858-bcb2-4fea-bd10-5c2662cb34a5)

### 文件夹Mat_Files

BC_ALL.mat：考虑所有因素作用的黑炭浓度

BC_PBL.mat：去除边界层因素作用的黑炭浓度

BC_RAIN.mat：去除降雨清除作用的黑炭浓度

BC_REAL.mat：真实黑炭浓度

BC_WIND.mat：去除风力输送影响的黑炭浓度

Boundary_layer_height_cal.mat：计算出来的边界层高度

Boundary_layer_height_real.mat：实际的边界层高度

### 文件夹TPBoundary_new

青藏高原的地形数据

### 数据

namco_data.xlsx：见第一个sheet数据说明。

namco_BC.xlsx：根据namco_data.xlsx中第4个sheet整理并另存的数据。纳木错站2020年8月至9月的黑炭浓度数据，时间分辨率1小时。

air.sig995.2020.nc：2020年$\sigma$为0.995层上的全球气温数据，时间分辨率为1天。共366个时间层次。

air.sig995.day.ltm.1991-2020.nc：1991-2020年$\sigma$为0.995层上的全球气候态日气温数据，时间分辨率为1天。共366个时间层次。每天的三十年平均气温。

air.sig995.mon.ltm.1991-2020.nc：1991-2020年$\sigma$为0.995层上的全球气候态月气温数据，时间分辨率为1月。共12个时间层次，每月的三十年平均气温。

prate.sfc.gauss.2020.nc：高斯格点上的2020年全球地表降水率，时间分辨率为1天。

tmax.2m.gauss.2020.nc：高斯格点上的2020年全球2m日最高气温，时间分辨率为1天。

tmin.2m.gauss.2020.nc：高斯格点上的2020年全球2m日最低气温，时间分辨率为1天。

uwnd.10m.gauss.2020.nc：高斯格点上的2020年全球10米纬向风速。

vwnd.10m.gauss.2020.nc：高斯格点上的2020年全球10米经向风速。

topo2deg.nc：全球地形数据，用来画图一地形的。

来源网址：[NCEP-NCAR Reanalysis 1: NOAA Physical Sciences Laboratory NCEP-NCAR Reanalysis 1](https://psl.noaa.gov/data/gridded/data.ncep.reanalysis.html)

代码运行问题联系：202183300708@nuist.edu.cn/3588430252@qq.com



