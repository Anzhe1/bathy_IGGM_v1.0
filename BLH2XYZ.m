function XYZcontent = BLH2XYZ(B,L,H)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   Bγ�ȣ�L���ȣ�H��ظ�0.0m
elipsePara(1) = 6378137.0; % a������
elipsePara(2) = 6356752.3142; % b�̰���
elipsePara(3) = 6399593.6258;  % c = a**2/b
elipsePara(4) = 1 / 298.257223563;  % ����
elipsePara(5) = 0.00669437999014132;  % ��һ����ƽ��
elipsePara(6) = 0.00673949674227;  % �ڶ�����ƽ��
    
    N = elipsePara(1) / (sqrt(1 - elipsePara(5) * power(sind(B),2)));
    x = (N + H) * cosd(B) * cosd(L);
    y = (N + H) * cosd(B) * sind(L);
    z = (N * (1 - elipsePara(5)) + H) * sind(B);
    XYZcontent = [x y z];
end

