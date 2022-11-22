function a=oo_stockQFQ_update_every_day()
    %%
    % clc
    % clear all
    % close all

    %%
    % 调用python程序下载数据
    %python('COPYTuShare_Stock_Today_All_20180307.py')
    data_name=dir('*.xlsx');
    data_name=data_name.name;
    date_num=datenum(data_name(1:end-4));
    data=importdata(data_name);
    delete(data_name)
    code=data.textdata;
    code=str2num(cell2mat(code(2:end,1)));
    data=data.data;
    data=data(:,4:end);
    %----------------------------------------
    sh_data=importdata('sh.csv');
    sh_data1=sh_data.data;
    sh_data2=sh_data.textdata;
    sh_data2=sh_data2(2:end,1);
    sh_data2=datenum(sh_data2);
    [sh_data2,num]=unique(sh_data2);
    sh_data1=sh_data1(num,:);
    sh=[sh_data2,sh_data1];
    delete('sh.csv')
    %--------------------------------------------
    sz_data=importdata('sz.csv');
    sz_data1=sz_data.data;
    sz_data2=sz_data.textdata;
    sz_data2=sz_data2(2:end,1);
    sz_data2=datenum(sz_data2);
    [sz_data2,num]=unique(sz_data2);
    sz_data1=sz_data1(num,:);
    sz=[sz_data2,sz_data1];
    delete('sz.csv')

    data_to=importdata('E:\WFJ\stockQFQ\Sina_Stock_China\data_today.csv')
    data_to=data_to.data;

    %%
    % 导入数据
     load('StockQFQ_update.mat')
    %eval(['StockQFQ.sh=','sh;'])
    %%
    h=waitbar(0,'处理文件中，请稍候！');

    for i =1:length(code)
           try  
             str=['处理文件中...',code(i),num2str(i/length(code)*100),'%'];waitbar(i/length(code),h,str)

            stock_id_num=num2str(code(i),'%06d');
            if str2num(stock_id_num(1))==6

                    stock_id=strcat('SH',stock_id_num);
            else
                stock_id=strcat('SZ',stock_id_num);
            end
            clear data_growth
            clear date_today
            eval(['data_growth=','StockQFQ.',stock_id,'.data_growth;']);
    %         date_today=[];
    %         date_today(1,1)=date_num-1;
    %         date_today(1,8)=data(i,1);
    %         date_today(1,5)=data(i,3);
    %         date_today(1,3)=data(i,4);
    %         date_today(1,4)=data(i,5);
    %         date_today(1,6)=data(i,6);
    %         date_today(1,10)=data(i,7);
    %         date_today(1,9)=data(i,8);
    %         date_today(1,11)=data(i,9);
    %         date_today(1,12)=data(i,12);
    %         date_today(1,13)=data(i,13);
    %         date_today(1,7)=data(i,13);
    %         date_today(:,end:end+8)=-99999;
    %         data_growth(end,2)=data(i,6);
    %         data_growth(end,7)=data_growth(end,2)-data_growth(end,6);

            [c r]=size(data_growth);

             %data_growth(end+1,:)=date_today;
             data_growth(:,end+1:end+9)=-99999;
             if  str2num(stock_id_num(1))==6   
                 [a,b,c]=intersect(data_growth(:,1),sh(:,1));
                 data_growth(b,r+1:r+9)=sh(c,2:end);

             else
                 [a,b,c]=intersect(data_growth(:,1),sz(:,1));
                 data_growth(b,r+1:r+9)=sz(c,2:end);

             end

             eval(['StockQFQ.',stock_id,'.data_growth=','data_growth;'])
           catch
           end

    end
    %% 还没写完程序，你要用可以用，不要关闭我的程序
    close(h)
   
    save('StockQFQ_update.mat','StockQFQ','-v7.3')

        
    
a=1