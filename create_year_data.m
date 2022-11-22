 clc
clear all
close all

load('StockQFQ.mat');
year_begin=datenum(str2num(datestr(now,'yyyy')),1,1);%获取今年1月1日

stock_ids=fieldnames(StockQFQ);
h=waitbar(0,'生成今年数据文件中，请稍候！');
for i=1:length(stock_ids)
    str=['生成今年数据文件中...',num2str(i/length(stock_ids)*100),'%'];waitbar(i/length(stock_ids),h,str)
    stock_id=stock_ids{i};
     
    clear data_growth
    clear data_today
    eval(['[m,n]=find(StockQFQ.',stock_id,'.data_growth(:,1)>=year_begin);']);
      
   try
         eval(['data_growth=','StockQFQ.',stock_id,'.data_growth(m,:);']);
         eval(['StockQFQ.',stock_id,'.data_growth=','data_growth;']);
   catch
        disp(['error:',stock_id,' unable to create'])
   end
    
    
end
close(h)
file_name=strcat('StockQFQ_',datestr(now,'yyyy'),'.mat')
 save(file_name,'StockQFQ','-v7.3')