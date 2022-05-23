% Target: find the second or third extremes in the vector
% extremes: (1) serial in N where extreme happens (2) freq. (3) energy

% return the value and location of the second extremes
function extremes= hfExtreme(vec,length)
 X = vec;
 extremes=zeros(1,2);
    
%�δ��ֵ������Ƶ����ĵ�һ���ֵ��
[pks,locs] = findpeaks(X);
[PeaksNum1 PeaksNum2] = size(pks);
% disp(PeaksNum1);
MaxPks = max(pks);
MaxPksIndex = find(pks==MaxPks);
MaxPksLLocs = locs(MaxPksIndex);%��Ƶλ��Ϊ0��

%�������ֵ
PksX = pks;
PksX(MaxPksIndex)=0;%�ѵڶ����ֵ���Ƴ�0
MaxPks1 = max(PksX);
MaxPksIndex1 = find(PksX==MaxPks1);
MaxPksLLocs1 = locs(MaxPksIndex1);

% extremes(1,1)=MaxPksLLocs;
% extremes(1,1)=MaxPksLLocs/length;
% extremes(1,2)=MaxPks;
% extremes(1,3)=MaxPksLLocs1;
%extremes(1,1)=MaxPksLLocs1/length;
extremes(1,1)=MaxPksLLocs1/length;
extremes(1,2)=MaxPks1;

% extremes(1,7)=sumPower;
% extremes(1,8)=PeaksNum1;

%  figure(n);
% plot(vec,'ro--');
% disp('extremes');
% disp(extremes);


end