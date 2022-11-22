function [a,b]=detect(data_name)
    load(data_name);  %加载数据
    f=fieldnames(StockQFQ);
    [c r]=eval(['size(StockQFQ.',f{1,1},'.data_growth)']);%获取StockQFQ.SH600000.data_growth的大小 【行  列】
    dat=eval(['StockQFQ.',f{1,1},'.data_growth(c,1)']);%读取最后一行,即最新时间，格式是datenum（时间戳）
    data=importdata('test.csv');%
    date_new=data.textdata{2,1};
    dat_num=datenum(date_new)-dat;%计算股票最新交易日期与数据的最新日期的间隔天数，date_new表示股票最新交易日期
    
    delete('test.csv')   
    if dat_num>1
        a='True';
        b=datestr(dat+1,"yyyy-mm-dd");
         
    else
         a='False';
         b=datestr(dat+1,"yyyy-mm-dd");
         
    end


