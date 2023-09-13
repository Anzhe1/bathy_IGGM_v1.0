function XYZcontent = BLH2XYZ(B,L,H)
%UNTITLED 此处显示有关此函数的摘要
%   B纬度；L经度；H大地高0.0m
elipsePara(1) = 6378137.0; % a长半轴
elipsePara(2) = 6356752.3142; % b短半轴
elipsePara(3) = 6399593.6258;  % c = a**2/b
elipsePara(4) = 1 / 298.257223563;  % 扁率
elipsePara(5) = 0.00669437999014132;  % 第一扁率平方
elipsePara(6) = 0.00673949674227;  % 第二扁率平方
    
    N = elipsePara(1) / (sqrt(1 - elipsePara(5) * power(sind(B),2)));
    x = (N + H) * cosd(B) * cosd(L);
    y = (N + H) * cosd(B) * sind(L);
    z = (N * (1 - elipsePara(5)) + H) * sind(B);
    XYZcontent = [x y z];
end

