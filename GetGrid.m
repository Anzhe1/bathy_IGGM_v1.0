%���ı�����ת��Ϊ��������
%FileNameΪ�ı�·��
%GridΪ ����ĸ�������  ��һ��Ϊ  ��һ��Ϊ   
function Grid=GetGrid(FileName)
    Data=load(FileName);
    Lon=Data(:,1)';Lat=Data(:,2);Value=Data(:,3)';
    %1  ��ȡLon�ĳ��Ⱥ�Lat�ĳ���
    X=unique (Lon) ;Y=unique (Lat);
    X_Num=length(X);Y_Num=length(Y);
    %2  ��Value���з���,ÿһ��ĸ�����X_Num+1,��Y_Num+1��
    Grid=zeros(Y_Num+1,X_Num+1);
    Grid(1,:)=[0,X];
    for j=Y_Num:-1:1
        Col=Y_Num-j;                                                                                                
        Grid(j+1,:)=[0,Value(Col*X_Num+1: Col*X_Num+X_Num)];
    end      
    Grid(:,1)=[0;Y];
end








