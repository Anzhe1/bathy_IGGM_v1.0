%%
clear;clc;
%Input all shiporned bathymetry points except check points
N=load(" ");
ncei=[N(:,1) N(:,2) N(:,3)];

%Input all control points (green and white points in the paper).
data=load(" ");
Lon=data(:,1);Lat=data(:,2);Depth=data(:,3);Gravity=data(:,4);
G=6.672*10^-8;%gravitational constant
PI=3.1416;
D=?;%Reference depth. Generally take the maximum depth
p=?;%The optimal value of Density contrast
k=?;%The optimal value of k
w=?;%Optimal computational radius

[r,s]=size(Depth);

parfor i=1:r
    %Same as iGGM_one
    Weights=[];
    lon_i=data(i,1);lat_i=data(i,2);depth_i=Depth(i);
    H=0.0;
    xyzcontent=[];
    xyzcontent(1,:)= BLH2XYZ(lat_i,lon_i,H);
   
    m1=lon_i+w;n1=lat_i+w;
    m2=lon_i-w;n2=lat_i-w;
    id=find(ncei(:,1)>m2 & ncei(:,1)<m1 & ncei(:,2)>n2 & ncei(:,2)<n1);
    sp_data=ncei(id,1:3);

    dep_i=sp_data(:,3);
    
      for j=1:size(dep_i,1)

   
    xyzcontent(j+1,:) = BLH2XYZ(sp_data(j,2),sp_data(j,1),H);
    distances=sqrt((xyzcontent(1,1)-xyzcontent(j+1,1))^2+(xyzcontent(1,2)-xyzcontent(j+1,2))^2+(xyzcontent(1,3)-xyzcontent(j+1,3))^2);
    angle=atand(distances/depth_i);
    Weights(j,1)=(cosd(angle))^k;   
      end
    g_j_short(i,1)=(sum(-2.*PI.*G.*p.*(dep_i-D).*10^5.*Weights))/(sum(Weights));
   
end
g_j_long=Gravity-g_j_short;

V=[Lon Lat g_j_long];

%Output the long-wavelength component
fid=fopen(' ','w');
[r,c]=size(V);         
for a=1:r
for b=1:c
fprintf(fid,'%f\t', V(a,b));
end
fprintf(fid,'\r\n');
end
fclose(fid);

%%
% GMT  processing in grid.bat 
%%
%% The grid depth model is calculated by using the long wave component after GMT processing.
clc;clear;
G=6.672*10^-8;
PI=3.1416;
D= ;%Reference depth. Generally take the maximum depth
p= ;%The optimal value of Density contrast
%Input the long-wavelength component of .xyz suffix after GMT processed. 
%such as: E:\IGGM\long_grd.xyz
data_long=load(" ");
%Input SIO V32.1 gravity anomaly model
lon_grav=ncread("E:\PHS\grav32_120-150-0-35.nc",'lon');
lat_grav=ncread("E:\PHS\grav32_120-150-0-35.nc.nc",'lat');
Grav=ncread("E:\PHS\grav32_120-150-0-35.nc",'z');
Grav=Grav';

data_long(:,4)=interp2(lon_grav,lat_grav,Grav,data_long(:,1),data_long(:,2),'spline');
gi_short=data_long(:,4)-data_long(:,3);

BAT=D-(gi_short./(2*PI*G*p*10^5));
data=[data_long(:,1) data_long(:,2)  -BAT];

% Output the bathymetry by IGGM. such as:E:\IGGM\BAT_Grid.txt
fid=fopen(' ','w');
[r,c]=size(data);       
for a=1:r
for b=1:c
fprintf(fid,'%f\t', data(a,b));
end
fprintf(fid,'\r\n');
end
fclose(fid);

%% Calculate the accuracy at the check points
% This part recalculates the predicted depths at the check points. 
%But you can also use the above model to interpolate directly to the check points
clc;clear;
G=6.672*10^-8;
PI=3.1416;
D= ? ;%Reference depth. Generally take the maximum depth
p= ? ;%The optimal value of Density contrast

%Input check points. Format: Longitude, latitude, depth, gravity anomaly
X_Y=load("  ");
depth0=X_Y(:,3);
g_i=X_Y(:,4);  %gravity anomaly

%Input the long-wavelength component of .xyz suffix after GMT processed. 
%such as: E:\IGGM\long_grd.xyz
FileName= strcat(" ");
Grid=GetGrid(FileName);
Lon=Grid(1,:);Lat=Grid(:,1);Lon(1)=[];Lat(1)=[];
Grid(1,:)=[];Grid(:,1)=[];gg=Grid;
g_i_long=interp2(Lon,Lat,gg,X_Y(:,1),X_Y(:,2),'spline');
g_i_short=g_i-g_i_long;

depth1=D-(g_i_short./(2*PI*G*p*10^5));

depth_cha=depth0-depth1;
STD=std((depth_cha));
RMS=rms((depth_cha));
f=corr(depth0,depth1,'type','Pearson');
Mean=mean(depth_cha);
Mean_abs=mean(abs(depth_cha));
Max=max(depth_cha);
Min=min(depth_cha);

ra_i=mean(abs(depth_cha)./abs(depth0))*100;
id=find(abs(depth_cha)<3*STD);new_error=depth_cha(id,1);
stdd=std(new_error);





