
clc;clear;

% Load the NetCDF file
file_path = '../Data/topo2deg.nc';
elevation = ncread(file_path, 'z');
lon = ncread(file_path, 'longitude');
lat = ncread(file_path, 'latitude');


min_lon = 70;
max_lon = 140;
min_lat = 15;
max_lat = 60;
lon_mask = (lon >= min_lon) & (lon <= max_lon);
lat_mask = (lat >= min_lat) & (lat <= max_lat);
lon_china = lon(lon_mask);
lat_china = lat(lat_mask);
elevation_china = elevation(lon_mask, lat_mask);
elevation_china=elevation_china';
non_land_value = -1;
elevation_china(elevation_china <= 0) = non_land_value;


[lon_china, lat_china] = meshgrid(lon_china, lat_china);

% colors = [
% 0.564705882	0.933333333	0.564705882	; %Light green (plains)
% 126.58180058/255, 145.68215553/255,113.55953533/255; %(higer plains)
% 0.678431373	1	0.184313725	;         %Yellow-green (foothills)
% 0.823529412	0.705882353	0.549019608	; %Light brown (lower mountains)
% 0.545098039	0.270588235	0.074509804	; %Brown (mountains)
% 0.360784314	0.250980392	0.2	;         %Dark brown (high mountains)
% 0.82745098	0.82745098	0.82745098	; %Light gray (snow-capped peaks)
% 1	1	1	;                         %White (highest peaks and snow)
% 
% ];

colors=[
     85  180  180 ;%（淡青色） 0 米:
 50  160  160 ;%（青色） 500 米:
 49  148  148 ;%（深青色），1000 米:
 150  115  115 ;%（棕色），2000 米:
 200  85  85 ;%（橙色），3000 米:
 225  100  100 ;%（浅红色），4000 米:
 245  200  200 ;%（淡灰色），5000 米:
 255  255  255 ;%（白色），6000 米:
    ];
colors=colors/255;
n_bins = 100;
cmap = interp1(linspace(0, 1, size(colors, 1)), colors, linspace(0, 1, n_bins));

% Plot the surface
figure;
surf(lon_china, lat_china, elevation_china, 'EdgeColor', 'none','FaceAlpha',0.8);
colormap(cmap);


xlim([min(min(lon_china)), max(max(lon_china))]);
ylim([min(min(lat_china)), max(max(lat_china))]);
zlim([0, max(elevation_china(:))]);
% yticks = get(gca, 'ytick');
yticks=linspace(20,55,8);
yticklabels = arrayfun(@(y) sprintf('%d°N', y), yticks, 'UniformOutput', false);
xticks = get(gca, 'xtick');
xticklabels = arrayfun(@(y) sprintf('%d°E', y), xticks, 'UniformOutput', false);
set(gca, 'yticklabel', yticklabels);
set(gca, 'xticklabel', xticklabels);
set(gca, 'FontName', 'Times New Roman');


grid off;
view(3);
hold on

% Read the shapefile
china_shapefile = 'D:\Maps\China2\china_country.shp';
china_shape = shaperead(china_shapefile);

% Plot the shapefile at elevation 0
for k = 1:length(china_shape)
    lon_shape = china_shape(k).X;
    lat_shape = china_shape(k).Y;
    
    % Plot the shapefile on the plane of elevation 0
    plot3(lon_shape, lat_shape, zeros(size(lon_shape)), 'k', 'LineWidth', 1);
end
