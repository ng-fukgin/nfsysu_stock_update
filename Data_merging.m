function a=Data_merging()
%%
% clc
% clear all
% close all
% warning off


%%  load data
load('StockQFQ.mat');
new=load('StockQFQ_update.mat');

%% merging data


stock_ids=fieldnames(StockQFQ);
h=waitbar(0,'处理文件中，请稍候！');
for i=1:length(stock_ids)
    str=['合并 结构体中...',num2str(i/length(stock_ids)*100),'%'];waitbar(i/length(stock_ids),h,str)
    stock_id=stock_ids{i};
    clear data_growth
    clear data_today
    eval(['data_growth=','StockQFQ.',stock_id,'.data_growth;']);
   try
         eval(['data_today=','new.StockQFQ.',stock_id,'.data_growth;']);
         
         [c r]=size(data_growth);
         if r>26
             % 玄学，会有些数据第27行后面复制前面的数据 
             data_growth(:,27:end)=[];
         end
         if r==22
             data_new=data_growth(:,end-8:end);
             data_growth(:,end-8:end)=[];
             data_growth(:,end+1:end+4)=-99999;
             data_growth(:,end+1:end+9)=data_new;
         end
         [cc rr]=size(data_today);
         data_growth(end+1:end+cc,:)=data_today;
         eval(['StockQFQ.',stock_id,'.data_growth=','data_growth;']);
   catch
        disp(['error:',stock_id,' unable to update'])
   end
    
    
end
close(h)
file_name=strcat('StockQFQ_',datestr(now,'yyyymmdd'),'.mat')

 %save(file_name,'StockQFQ','-v7.3')
 save('StockQFQ.mat','StockQFQ','-v7.3')
 create_year_data
 a=1
    
