%将文本数据转换为格网数据
%FileName为文本路径
%Grid为 输出的格网数据  第一行为  第一列为   
function Grid=GetGrid(FileName)
    Data=load(FileName);
    Lon=Data(:,1)';Lat=Data(:,2);Value=Data(:,3)';
    %1  读取Lon的长度和Lat的长度
    X=unique (Lon) ;Y=unique (Lat);
    X_Num=length(X);Y_Num=length(Y);
    %2  对Value进行分组,每一组的个数是X_Num+1,共Y_Num+1组
    Grid=zeros(Y_Num+1,X_Num+1);
    Grid(1,:)=[0,X];
    for j=Y_Num:-1:1
        Col=Y_Num-j;                                                                                                
        Grid(j+1,:)=[0,Value(Col*X_Num+1: Col*X_Num+X_Num)];
    end      
    Grid(:,1)=[0;Y];
end








