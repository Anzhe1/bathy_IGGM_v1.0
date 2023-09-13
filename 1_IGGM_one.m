%% Sorry, the program was poorly written. The overall structure and computational efficiency need to be further improved. 
%If you have any comments and suggestions, don't hesitate to contact me andechao1@126.com

clear;clc;
%All the shiporned bathymetry points used have been eliminated by gross error
%Input all shiporned bathymetry points except check points
filename1=" "
N=load(filename1);
ncei=[N(:,1) N(:,2) N(:,3)];
%Input control points used to calculate the  initial model (green points in the paper).
%Notice: The depth of the water needs to be the same sign, so let's take a positive here.
%Data format: Longitude, latitude, depth, gravity anomaly
filename2=" "
data=load(" ");
Lon=data(:,1);Lat=data(:,2);
Depth=data(:,3);% shipborned bathymetry from NCEI.
Gravity=data(:,4); %gravity anomaly
G=6.672*10^-8;%gravitational constant
PI=3.1416;
D=10070;%Reference depth. Generally take the maximum depth
pp=[0.1:0.1:5];%Density contrast
k=[0.5:0.5:7]; %The index of the weight
rr=[1/60:1/60:30/60];%Calculated radius unit: °
[r,s]=size(Depth);

filename_savepath=" " %The path to save the output. such as:E:\PHS_10deg_grid\phs_120-130_5-15\data\

for n=1:length(pp)
    p=pp(n);
    savepath='filename_savepath';
    file_name = sprintf('%s',num2str(p));
    file_path_name = strcat(savepath,'p_',file_name);
    file_path_name_= strcat(file_path_name,'');
     if exist(file_path_name_)==0 
        mkdir(file_path_name_);
        else
        rmdir(file_path_name_, 's'); 
        mkdir(file_path_name_);
     end


for nn=1:length(rr)
    r=rr(nn);
    file_name_R = sprintf('%s',num2str(r*60));
    file_path_name_R = strcat(file_path_name_,'\R_',file_name_R);
    file_path= strcat(file_path_name_R,'');
     if exist(file_path)==0 
        mkdir(file_path);
        else 
        rmdir(file_path, 's'); 
        mkdir(file_path);
     end
for nnn=1:length(k)  
m=k(nnn);
parfor i=1:r

    Weights=[];
    %Latitude, longitude and depth of center point
    lon_i=data(i,1);lat_i=data(i,2);depth_i=Depth(i);

    H=0.0;
    xyzcontent=[];
    % Latitude, longitude, geodetic height
    xyzcontent(1,:)= BLH2XYZ(lat_i,lon_i,H);
    %The calculation of shipborned  points within the preset range is screened
    m1=lon_i+r;n1=lat_i+r;
    m2=lon_i-r;n2=lat_i-r;
    id=find(ncei(:,1)>m2 & ncei(:,1)<m1 & ncei(:,2)>n2 & ncei(:,2)<n1);

    sp_data=ncei(id,1:3);
    dep_i=sp_data(:,3);

      for j=1:size(dep_i,1)
         
          xyzcontent(j+1,:) = BLH2XYZ(sp_data(j,2),sp_data(j,1),H);
          %The distance between the center point and the surrounding point
          distances=sqrt((xyzcontent(1,1)-xyzcontent(j+1,1))^2+(xyzcontent(1,2)-xyzcontent(j+1,2))^2+(xyzcontent(1,3)-xyzcontent(j+1,3))^2);
          %Calculate the angle between the center point and the surrounding point 
          angle=atand(distances/depth_i); 
          %Calculate the weights corresponding to the surrounding points
          Weights(j,1)=(cosd(angle))^m;
      end


    %The short-wavelength gravity anomaly after IGGM correction is calculated
    g_j_short(i,1)=(sum(-2.*PI.*G.*p.*(dep_i-D).*10^5.*Weights))/(sum(Weights));
    
end
 %The long-wavelength gravity anomaly
g_j_long=Gravity-g_j_short;

clear g_j_short Weights angle distances xyzcontent sp_data dep_i

    V=[Lon Lat g_j_long];
    fid=fopen([file_path,'\b',num2str(nnn),'.txt'],'w');
   [r,c]=size(V);        
     for a=1:r
        for b=1:c
            fprintf(fid,'%f\t', V(a,b));
        end
        fprintf(fid,'\r\n');
     end
     fclose(fid);
     
clear g_j_long
end
end
end
