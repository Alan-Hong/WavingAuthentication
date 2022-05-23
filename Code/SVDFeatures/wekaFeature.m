%%计算SVD
function [ wekaFeature ] = wekaFeature( path )
file=dir([path '*FastAccGyro.txt']);
wekaFeature=zeros(size(file,1),20);
for i=1:size(file,1)
    disp(file(i).name);
    data=dlmread([path,file(i).name]);
    %计算SVD
    [U sigma V]=svd(data(:,3:5),0); 
    
    %计算U矩阵与sigma矩阵的合加速度均值与方差
    accdata=[U*sigma];
    accelXYZMean = mean(accdata);    %XYZ三轴的均值U*sigma
    accelXYZStd = std(accdata);      %XYZ三轴的方差U*sigma
    comdata=(accdata(:,1).^2+accdata(:,2).^2+accdata(:,3).^2).^0.5; %合加速度U*sigma
    accelComMean = mean(comdata);    %合加速度均值U*sigma
    accelComStd = std(comdata);      %合加速度方差U*sigma
    
%     %计算U矩阵均值与方差
%     accelXYZMean1 = mean(U);    %XYZ三轴的均值U
%     accelXYZStd1 = std(U);      %XYZ三轴的方差U
%     comdata1=(U(:,1).^2+U(:,2).^2+U(:,3).^2).^0.5; %合加速度U
%     accelComMean1 = mean(comdata1);    %合加速度均值U
%     accelComStd1 = std(comdata1);      %合加速度方差U
    
    %%计算U1的第二（或一）大极值与频率
    absft=abs(fft(U(:,1)));
    basefreq=absft(2:20)/mean(absft);
    vec1=hfExtreme(basefreq,length(absft)); % freq. or sequence is considered in hfExtreme除去级基频以外的第二大极值
    
    %%计算U2的第二（或一）大极值与频率
    absft2=abs(fft(U(:,2)));
    basefreq2=absft2(2:20)/mean(absft2);
    vec2=hfExtreme(basefreq2,length(absft2)); % freq. or sequence is considered in hfExtreme除去级基频以外的第二大极值 
    %%计算U3的第二（或一）大极值与频率
    absft3=abs(fft(U(:,2)));
    basefreq3=absft3(2:20)/mean(absft3);
    vec3=hfExtreme(basefreq3,length(absft3)); % freq. or sequence is considered in hfExtreme除去级基频以外的第二大极值 
    
%     wekaFeature(i,1:4)=vec1;
%     wekaFeature(i,5:8)=vec2;
%     wekaFeature(i,9:12)=vec3;
    
    
    %%sigma特征
    sigFeature(1,1)=sigma(1,1);
    sigFeature(1,2)=sigma(2,2);
    sigFeature(1,3)=sigma(3,3); 
    sigsum=sum(sigFeature(1,1:3));
    sigFeatures(1,1:3)=sigFeature(1,1:3)/sigsum;
    
%     过零率（超过重力加速度的次数）
    PassZeroX = 0;
    PassZeroY = 0;
    PassZeroZ = 0;
%     PassZeroCom = 0;
    for j = 1:length(accdata(:,1))-1
       if accdata(j,1)>=0 & accdata(j+1,1)<0 || accdata(j,1)<0 &accdata(j+1,1)>=0
           PassZeroX = PassZeroX+1;
       end
     end;
     for j = 1:length(accdata(:,2))-1
       if accdata(j,2)>=0 & accdata(j+1,2)<0 || accdata(j,2)<0 &accdata(j+1,2)>=0
           PassZeroY = PassZeroY+1;
       end
     end;
     for j = 1:length(accdata(:,3))-1
       if accdata(j,3)>=0 & accdata(j+1,3)<0 || accdata(j,3)<0 &accdata(j+1,3)>=0
           PassZeroZ = PassZeroZ+1;
       end
     end;
    wekaFeature(i,1:3)=sigFeatures;
    wekaFeature(i,4:5)=vec1;
    wekaFeature(i,6:7)=vec2;
    wekaFeature(i,8:9)=vec3;
    wekaFeature(i,10:12)= accelXYZMean;
    wekaFeature(i,13:15)=accelXYZStd;
    wekaFeature(i,16)=accelComMean;
    wekaFeature(i,17)=accelComStd;
    wekaFeature(i,18)=PassZeroX;
    wekaFeature(i,19)=PassZeroY;
    wekaFeature(i,20)=PassZeroZ;  
end



end

