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
    display('寻优结束后，test the trainingdata 的结果：')
    display(['xalidcorrect=',num2str(xalidcorrect)]);
    display(xalidvErro);

    vgroup=zeros(ltestAll,1); 
    vgroup(ltest+1:ltestAll)=vgroup(ltest+1:ltestAll)+1;
    [vpredict_label, vaccuracy, vdec_values] =svmpredict(vgroup, vdata, model); % test the testing data
    validcorrectTP=sum(vpredict_label(1:ltest)==1)/ltest;
    validcorrectFP=sum(vpredict_label(ltest+1:ltestAll)==1)/(ltestAll-ltest);  % false positive rate
    validcorrect=(sum(vpredict_label(1:ltest)==1)+sum(vpredict_label(ltest+1:ltestAll)==-1))/ltestAll;
    validvfp=find(vpredict_label(ltest+1:ltestAll)==1);
    display('寻优结束后，test the testing set 的结果');
    display(['validcorrectTP=',num2str(validcorrectTP)]);
    display(['validcorrectFP=',num2str(validcorrectFP)]);
    display(['validcorrect=',num2str(validcorrect)]);
    display(validvfp);
    display(bestSig);
    display(bestn);
    display('**************************************');
    dlmwrite('寻优的结果.txt', '**************************************','-append','delimiter',' ');
    dlmwrite('寻优的结果.txt', bestn,'-append','delimiter',' ');
    dlmwrite('寻优的结果.txt', bestSig,'-append','delimiter',' ');
    dlmwrite('寻优的结果.txt', xalidcorrect ,'-append','delimiter',' ');
    dlmwrite('寻优的结果.txt', validcorrectTP,'-append','delimiter',' ');
    dlmwrite('寻优的结果.txt', validcorrectFP,'-append','delimiter',' ');
end

