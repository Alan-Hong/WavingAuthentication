%% 攻击数据的离线测试
% one-SVM 用的是libsvm 3.11 分割面是平面
% 预测的正样本的标签是1
% 预测的负样本的标签是-1
clear all; close all; clc;clear;
trainDataPath = '攻击数据\attack补IntrudingContestRawData20150131\weiswwsww20150130\swwsww wei20150130Afternoon\';
xdata1 = wekaFeature( trainDataPath );
xdata = xdata1(:,[13 1 11 14 2 16]);

% cross validation set
path = '攻击数据\attack补IntrudingContestRawData20150131\weiswwsww20150130\swwsww wei20150130Night\';
data1 = wekaFeature( path );
vdata1 = data1(:,[13 1 11 14 2 16]);

% testing set
path = '攻击数据\attack补IntrudingContestRawData20150131\weiswwsww20150130\swwsww wei20150130Morning\';
tdata1 = wekaFeature( path );
testData1 = tdata1(:,[13 1 11 14 2 16]);

testDataPath = '攻击数据\attack补IntrudingContestRawData20150131\liufei20150131\swwsww liufei20150131Morning\';
testData = wekaFeature(testDataPath); 
testData = testData(:,[13 1 11 14 2 16]);

%% 只用owner的数据作cross validation
% bestSig = 0;
% bestcorrect = 0;
% bestn =0;
% 
% ltrain=size(xdata,1);
% ltest=0;
% 
% xgroup=zeros(ltrain,1)+1;
% % for i=0.001:0.01:1
% %     for j=0.001:0.01:1
% %    cmd=['-s',' 2',' -g ',  num2str(i),' -n ',num2str(j)];%num2str(i)
% for i = 0.001:0.05:1
%      for log2g = -5 :0.5: 5,       
%         j = 2^log2g; 
%         cmd=['-s',' 2',' -g ',  num2str(j),' -n ',num2str(i)];%num2str(i)
%         model= svmtrain(xgroup,xdata, cmd);
%         [xpredict_label, xaccuracy, xdec_values] =svmpredict(xgroup, xdata, model); % test the trainingdata
%         xalidcorrect=sum(xpredict_label(1:ltrain)==1)/ltrain;
%         xalidvErro=find(xpredict_label(1:ltrain)==-1);
%         display('寻优中train完，测试train set 的结果：');
%         display(['xalidcorrect=',num2str(xalidcorrect)]);
%         display(xalidvErro);
% 
%         vdata=vdata1;
%         ltest=size(vdata1,1);
%         ltestAll=size(vdata,1);
%         vgroup=zeros(ltestAll,1); 
%         vgroup(ltest+1:ltestAll)=vgroup(ltest+1:ltestAll)-1;
%         [vpredict_label, vaccuracy, vdec_values] =svmpredict(vgroup, vdata, model); % test the validation set
%         validcorrectTP=sum(vpredict_label(1:ltest)==1)/ltest;
%         validcorrectFP=sum(vpredict_label(ltest+1:ltestAll)==1)/(ltestAll-ltest);
%         validcorrect=(sum(vpredict_label(1:ltest)==1)+sum(vpredict_label(ltest+1:ltestAll)==-1))/ltestAll;
%         validvfp=find(vpredict_label(ltest+1:ltestAll)==1);
%         display(['validcorrectTP=',num2str(validcorrectTP)]);
%         display(['validcorrectFP=',num2str(validcorrectFP)]);
%         display(['validcorrect=',num2str(validcorrect)]);
%         display('validvfp=');
%         disp(validvfp);
%         if  validcorrect>bestcorrect
%                  bestcorrect =  validcorrect;
%                  bestSig = i;
%                  bestn=j;
%         end
%  end;
% end;
% vdata = [testData1;testData];
% ltest=size(testData1,1);
% TrainOneSVM(bestSig,bestn,xdata,vdata,ltest);


%% 为了画ROC曲线，用testdata做测试
ltrain=size(xdata,1);
ltest=0;
xgroup=zeros(ltrain,1)+1;
% for nu = 0.001:0.01:1
for nu = 0.001:0.05:1
    gammaSeq = [];
    xalidcorrectSeq = [];
    validcorrectTPSeq = [];
    validcorrectFPSeq = [];
 for log2g = -5 :0.5: 5,
        vdata = [testData1;testData];
        ltest=size(testData1,1);
        
        gamma = 2^log2g; 
        
        display('****************************************');
        display('寻优结束后，构建的model：')
        ltrain=size(xdata,1);
        ltestAll=size(vdata,1);
        xgroup=zeros(ltrain,1)+1;
        cmd=['-s',' 2',' -g ', num2str(gamma),' -n ',num2str(nu)];%num2str(i)
        model= svmtrain(xgroup,xdata, cmd);

        display('寻优结束后，test the trainingdata 的结果：');
        [xpredict_label, xaccuracy, xdec_values] =svmpredict(xgroup, xdata, model); % test the trainingdata
        xalidcorrect=sum(xpredict_label(1:ltrain)==1)/ltrain;
        xalidvErro=find(xpredict_label(1:ltrain)==-1);
        display(['xalidcorrect=',num2str(xalidcorrect)]);
        display('xalidvErro:');
        display(xalidvErro);

        vgroup=zeros(ltestAll,1);
        if ltest==0
            vgroup=vgroup-1;
        end
        if ltest>=1
            vgroup(1:ltest)=vgroup(1:ltest)+1;
            vgroup(ltest+1:ltestAll)=vgroup(ltest+1:ltestAll)-1;
        end
        display('寻优结束后，test the testing set 的结果');
        [vpredict_label, vaccuracy, vdec_values] =svmpredict(vgroup, vdata, model); % test the testing data
        validcorrectTP=sum(vpredict_label(1:ltest)==1)/ltest;
        validcorrectFP=sum(vpredict_label(ltest+1:ltestAll)==1)/(ltestAll-ltest);  % false positive rate
        validcorrect=(sum(vpredict_label(1:ltest)==1)+sum(vpredict_label(ltest+1:ltestAll)==-1))/ltestAll;
        validvfp=find(vpredict_label(ltest+1:ltestAll)==1);
        display(['validcorrectTP=',num2str(validcorrectTP)]);
        display(['validcorrectFP=',num2str(validcorrectFP)]);
        display(['validcorrect=',num2str(validcorrect)]);
        display(validvfp);
        display(gamma);
        display(nu);
        display('**************************************');
       gammaSeq = [gammaSeq gamma];
       xalidcorrectSeq = [xalidcorrectSeq; xalidcorrect];
       validcorrectTPSeq = [validcorrectTPSeq; validcorrectTP];
       validcorrectFPSeq = [validcorrectFPSeq;validcorrectFP];
      
 end;
dlmwrite('每次循环的结果.txt', '**************************************','-append','delimiter',' ');
dlmwrite('每次循环的结果.txt', nu,'-append','delimiter',' ');
dlmwrite('每次循环的结果.txt', gammaSeq,'-append','delimiter',' ');
dlmwrite('每次循环的结果.txt', xalidcorrectSeq ,'-append','delimiter',' ');
dlmwrite('每次循环的结果.txt', validcorrectTPSeq,'-append','delimiter',' ');
dlmwrite('每次循环的结果.txt', validcorrectFPSeq,'-append','delimiter',' ');
      
figure, plot(gammaSeq,xalidcorrectSeq,'k+-','LineWidth',2);
hold on;
plot(gammaSeq,validcorrectTPSeq,'go-','LineWidth',2);

plot(gammaSeq,validcorrectFPSeq,'r+-','LineWidth',2);
hold off;

legend('TPR of training set', 'TPR of testing set', 'FPR of tesing set');
xlabel('gamma');
ylim([0 1]);
title(['nu= ' num2str(nu)]);
% ylabel('Test Error');
end;

%% 手动参数设置
% ltrain=size(xdata,1);
% ltest=0;
% xgroup=zeros(ltrain,1)+1;
% % for nu = 0.001:0.01:1
% nu = 0.001;
% log2g = -5+2*0.5;
%         vdata = [testData1;testData];
%         ltest=size(testData1,1);
%         
%         gamma = 2^log2g; 
%         
%         display('****************************************');
%         display('寻优结束后，构建的model：')
%         ltrain=size(xdata,1);
%         ltestAll=size(vdata,1);
%         xgroup=zeros(ltrain,1)+1;
%         cmd=['-s',' 2',' -g ', num2str(gamma),' -n ',num2str(nu)];%num2str(i)
%         model= svmtrain(xgroup,xdata, cmd);
% 
%         display('寻优结束后，test the trainingdata 的结果：');
%         [xpredict_label, xaccuracy, xdec_values] =svmpredict(xgroup, xdata, model); % test the trainingdata
%         xalidcorrect=sum(xpredict_label(1:ltrain)==1)/ltrain;
%         xalidvErro=find(xpredict_label(1:ltrain)==-1);
%         display(['xalidcorrect=',num2str(xalidcorrect)]);
%         display('xalidvErro:');
%         display(xalidvErro);
% 
%         vgroup=zeros(ltestAll,1);
%         if ltest==0
%             vgroup=vgroup-1;
%         end
%         if ltest>=1
%             vgroup(1:ltest)=vgroup(1:ltest)+1;
%             vgroup(ltest+1:ltestAll)=vgroup(ltest+1:ltestAll)-1;
%         end
%         display('寻优结束后，test the testing set 的结果');
%         [vpredict_label, vaccuracy, vdec_values] =svmpredict(vgroup, vdata, model); % test the testing data
%         validcorrectTP=sum(vpredict_label(1:ltest)==1)/ltest;
%         validcorrectFP=sum(vpredict_label(ltest+1:ltestAll)==1)/(ltestAll-ltest);  % false positive rate
%         validcorrect=(sum(vpredict_label(1:ltest)==1)+sum(vpredict_label(ltest+1:ltestAll)==-1))/ltestAll;
%         validvfp=find(vpredict_label(ltest+1:ltestAll)==1);
%         display(['validcorrectTP=',num2str(validcorrectTP)]);
%         display(['validcorrectFP=',num2str(validcorrectFP)]);
%         display(['validcorrect=',num2str(validcorrect)]);
%         display(validvfp);
%         display(gamma);
%         display(nu);
%         display('**************************************');
%        gammaSeq = gamma;
%        xalidcorrectSeq =  xalidcorrect;
%        validcorrectTPSeq = validcorrectTP;
%        validcorrectFPSeq = validcorrectFP;
% dlmwrite('每次循环的结果.txt', '**************************************','-append','delimiter',' ');
% dlmwrite('每次循环的结果.txt', nu,'-append','delimiter',' ');
% dlmwrite('每次循环的结果.txt', gammaSeq,'-append','delimiter',' ');
% dlmwrite('每次循环的结果.txt', xalidcorrectSeq ,'-append','delimiter',' ');
% dlmwrite('每次循环的结果.txt', validcorrectTPSeq,'-append','delimiter',' ');
% dlmwrite('每次循环的结果.txt', validcorrectFPSeq,'-append','delimiter',' ');


