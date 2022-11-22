function a=peTTM()
    clc
    clear all
    warning off
    %%
    % load data
    % % xlsxPath = '.\CSV_Hist_Data\';        % xlsx库路径
    xlsxPath = '.\peTTM\';        % xlsx库路径

    xlsxDir  = dir([xlsxPath '*.csv']); % 遍历所有xlsx格式文件
    h=waitbar(0,'处理文件中，请稍候！');
    load('StockQFQ_update.mat')

    for i = 1:length(xlsxDir)          % 遍历结构体就可以一一处理xlsx了
        try

          str=['处理文件中...',num2str(i/(length(xlsxDir))*100),'%'];waitbar(i/(length(xlsxDir)),h,str)
            stock_id_num=split(xlsxDir(i).name,'.');
                stock_id_num=stock_id_num{1};
                  if str2num(stock_id_num(1))==6

                    stock_id=strcat('SH',stock_id_num);
            else
                stock_id=strcat('SZ',stock_id_num);
            end
                eval(['data_growth=','StockQFQ.',stock_id,'.data_growth;']);
                data_growth(:,end+1:end+4)=-99999;
                 filepath=[xlsxPath xlsxDir(i).name];
                  data=importdata(filepath);
                  try
                  data1=data.data;
                    data2=data.textdata;
                    data2=data2(2:end,1);
                    data2=datenum(data2);
                    [data2,num]=unique(data2);
                    data1=data1(num,2:end);
                    p_data=[data2,data1];
                    [a,b,c]=intersect(data_growth(:,1),p_data(:,1));
                    [z r]=size(data_growth);
                    data_growth(b,r-3:r)=p_data(c,2:end);
                  catch 
                  end
                    
                     
                    eval(['StockQFQ.',stock_id,'.data_growth=','data_growth;'])
        catch
        end
    end
    close(h);
    file_name=strcat('StockQFQ_update_',datestr(now,'yyyymmdd'),'.mat')
    %save(file_name)
    save('StockQFQ_update.mat','StockQFQ','-v7.3')
    %exit()
    a=1
