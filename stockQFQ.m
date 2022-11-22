function a=stockQFQ()
%%
    clc
    clear all
    warning off
    %%
    % load data
    % % xlsxPath = '.\CSV_Hist_Data\';        % xlsx��·��
    xlsxPath = '.\quotes\';        % xlsx��·��

    xlsxDir  = dir([xlsxPath '*.csv']); % ��������xlsx��ʽ�ļ�
    h=waitbar(0,'�����ļ��У����Ժ�');
    J=0;
    for i = 1:length(xlsxDir)          % �����ṹ��Ϳ���һһ����xlsx��
        try

            stock_id_num=split(xlsxDir(i).name,'.');
                stock_id_num=stock_id_num{1};
            if str2num(stock_id_num(1))==6
                J=J+1;
                 str=['�����ļ���...',num2str(J/(length(xlsxDir))*100),'%'];waitbar(J/(length(xlsxDir)),h,str)
                filepath=[xlsxPath xlsxDir(i).name];

                stock_id=strcat('SH',stock_id_num);

                data=importdata(filepath);
                %%
                data1=data.textdata;
                data1(1,:)=[];
                data1(:,1)=[];
                date_num=datenum(data1(:,1)); 
                [date_num,num]=unique(date_num);
                %%
                data2=data.data;
                data2=data2(num,:);



                %%
                data_growth=[date_num,data2];
                %%  
        % %         data_growth(:,end+1)=-9999;
        % %           %%
        % %         %----------------------------------------------------
        % %         try
        % %              data_quotes=importdata(strrep(strrep(filepath,'CSV_Hist_Data','quotes'),'xlsx','csv'));
        % %             %%
        % %             quotes_data=data_quotes.textdata;
        % %             quotes_data(1,:)=[];
        % %             quotes_date_num=datenum(quotes_data(:,1)); 
        % %             [quotes_date_num,num2]=unique(quotes_date_num);
        % %             quotes_money=data_quotes.data;
        % %             quotes_money=quotes_money(num2,10);
        % %             [a,b,c]=intersect(quotes_date_num,data_growth(:,1));
        % %             data_growth(c,end)=quotes_money(b);
        % %         catch
        % %         end
                %%
                [c r]=size(data_growth);
                if r>21
                   fdf
                end
                eval(['StockQFQ.',stock_id,'.stock_id=','stock_id;']);
                eval(['StockQFQ.',stock_id,'.stock_id_num=','stock_id_num;']);
                eval(['StockQFQ.',stock_id,'.data_growth=','data_growth;'])
           else

           end
         catch
        end


    end

    %-------------------------------------------------------------------
    for i = 1:length(xlsxDir)          % �����ṹ��Ϳ���һһ����xlsx��
        try

            stock_id_num=split(xlsxDir(i).name,'.');
                stock_id_num=stock_id_num{1};
            if str2num(stock_id_num(1))~=6
                J=J+1;
                 str=['�����ļ���...',num2str(J/(length(xlsxDir))*100),'%'];waitbar(J/(length(xlsxDir)),h,str)
                filepath=[xlsxPath xlsxDir(i).name];

                stock_id=strcat('SZ',stock_id_num);

                data=importdata(filepath);
                %%
                data1=data.textdata;
                data1(1,:)=[];
                data1(:,1)=[];
                date_num=datenum(data1(:,1)); 
                [date_num,num]=unique(date_num);
                %%
                data2=data.data;
                data2=data2(num,:);



                %%
                data_growth=[date_num,data2];
                %%  
        % %         data_growth(:,end+1)=-9999;
        % %           %%
        % %         %----------------------------------------------------
        % %         try
        % %              data_quotes=importdata(strrep(strrep(filepath,'CSV_Hist_Data','quotes'),'xlsx','csv'));
        % %             %%
        % %             quotes_data=data_quotes.textdata;
        % %             quotes_data(1,:)=[];
        % %             quotes_date_num=datenum(quotes_data(:,1)); 
        % %             [quotes_date_num,num2]=unique(quotes_date_num);
        % %             quotes_money=data_quotes.data;
        % %             quotes_money=quotes_money(num2,10);
        % %             [a,b,c]=intersect(quotes_date_num,data_growth(:,1));
        % %             data_growth(c,end)=quotes_money(b);
        % %         catch
        % %         end
                %%
                [c r]=size(data_growth);
                if r>21
                   fdf
                end
                eval(['StockQFQ.',stock_id,'.stock_id=','stock_id;']);
                eval(['StockQFQ.',stock_id,'.stock_id_num=','stock_id_num;']);
                eval(['StockQFQ.',stock_id,'.data_growth=','data_growth;'])
           else

           end
          catch
        end


    end

    close(h);
    file_name=strcat('StockQFQ_update_',datestr(now,'yyyymmdd'),'.mat')
    %save(file_name)
    save('StockQFQ_update.mat','StockQFQ','-v7.3')
    %exit()
a=1

