function  TrainOneSVM( bestSig,bestn,xdata,vdata,ltest )
    ltrain=size(xdata,1);
    ltestAll=size(vdata,1);

    xgroup=zeros(ltrain,1);
    cmd=['-s',' 2',' -g ', num2str(bestSig),' -n ',num2str(bestn)];%num2str(i)
    model= svmtrain(xgroup,xdata, cmd);
    [xpredict_label, xaccuracy, xdec_values] =svmpredict(xgroup, xdata, model); % test the trainingdata
    xalidcorrect=sum(xpredict_label(1:ltrain)==1)/ltrain;
    xalidvErro=find(xpredict_label(1:ltrain)==-1);
    display('****************************************');
    display('Ѱ�Ž�����test the trainingdata �Ľ����')
    display(['xalidcorrect=',num2str(xalidcorrect)]);
    display(xalidvErro);

    vgroup=zeros(ltestAll,1); 
    vgroup(ltest+1:ltestAll)=vgroup(ltest+1:ltestAll)+1;
    [vpredict_label, vaccuracy, vdec_values] =svmpredict(vgroup, vdata, model); % test the testing data
    validcorrectTP=sum(vpredict_label(1:ltest)==1)/ltest;
    validcorrectFP=sum(vpredict_label(ltest+1:ltestAll)==1)/(ltestAll-ltest);  % false positive rate
    validcorrect=(sum(vpredict_label(1:ltest)==1)+sum(vpredict_label(ltest+1:ltestAll)==-1))/ltestAll;
    validvfp=find(vpredict_label(ltest+1:ltestAll)==1);
    display('Ѱ�Ž�����test the testing set �Ľ��');
    display(['validcorrectTP=',num2str(validcorrectTP)]);
    display(['validcorrectFP=',num2str(validcorrectFP)]);
    display(['validcorrect=',num2str(validcorrect)]);
    display(validvfp);
    display(bestSig);
    display(bestn);
    display('**************************************');
    dlmwrite('Ѱ�ŵĽ��.txt', '**************************************','-append','delimiter',' ');
    dlmwrite('Ѱ�ŵĽ��.txt', bestn,'-append','delimiter',' ');
    dlmwrite('Ѱ�ŵĽ��.txt', bestSig,'-append','delimiter',' ');
    dlmwrite('Ѱ�ŵĽ��.txt', xalidcorrect ,'-append','delimiter',' ');
    dlmwrite('Ѱ�ŵĽ��.txt', validcorrectTP,'-append','delimiter',' ');
    dlmwrite('Ѱ�ŵĽ��.txt', validcorrectFP,'-append','delimiter',' ');
end

