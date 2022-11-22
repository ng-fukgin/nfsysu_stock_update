import time
import baostock as bs
import os 
import socks
import socket
#socks.setdefaultproxy(socks.PROXY_TYPE_SOCKS5, "127.0.0.1", 49747)
socket.socket = socks.socksocket
import random
import requests
import urllib
socket.setdefaulttimeout(30) #设置10秒后连接超时
time_create= time.strftime('%Y%m%d%H%M%S',time.localtime(time.time()))
import nfsysu_stock_upadate
import pandas  as pd
try:
    import matlab
    import matlab.engine
except:
    raise Exception(r"请先配置matlab使得python能够调用  \n  https://ng-fukgin.gitee.io/%E6%95%99%E7%A8%8B/2022/01/25/MATLAB_Engine_for_Python/")

class Update:
    def __init__(self,start_date,end_date):
        self.start_date=start_date
        self.end_date=end_date
        self.lg = bs.login()
        print('start date:',self.start_date,'end date:',self.end_date)
        try:
            b=start_date.split('-')
            b[0]+b[1]+b[2]
            b=end_date.split('-')
            b[0]+b[1]+b[2]
        except:
            raise Exception('请输入正确的日期格式，例如1990-01-01')
    def downloadFile(self):
        if  os.path.exists(self.file_name):
            pass
        else:
            urllib.request.urlretrieve(self.url,self.file_name)
    def code_stanard(self,standard_type=0):#编码标准化
        if standard_type==1:
            if not (str(self.code_id).startswith('sh') or str(self.code_id).startswith('sz')):#code id 标准化
                self.code_id=(self.code_id.zfill(6))
                if self.code_id.startswith('6'):
                    self.code_id='sh.'+str(self.code_id)
                else:
                    self.code_id='sz.'+str(self.code_id)
        else:
            if  str(self.code_id).startswith('sh') :
                self.code_id=(self.code_id).replace('sh.','0')
            elif  str(self.code_id).startswith('sz') :
                self.code_id=(self.code_id).replace('sz.','1')
            elif i[0]=='6':
                    self.code_id='0'+self.code_id
            else:
                    self.code_id='1'+self.code_id
        return self.code_id      

    def dowload_from_sina(self,code_id,file_name):#下载股票历史数据
    
        self.file_name=file_name
        self.code_id=code_id
        self.code=self.code_stanard()
        self.sina_url='http://quotes.money.163.com/service/chddata.html?code='+self.code+'&start='+(self.start_date).replace('-','')+'&end='+(self.end_date).replace('-','')+'&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;TURNOVER;VOTURNOVER;VATURNOVER;TCAP;MCAP'
        self.url=self.sina_url
        try:
            self.downloadFile()
        except:
            pass
        return(self.sina_url)
    
    def dowload_from_baostock(self,code_id,file_name):#下载股票   滚动市盈率  滚动市销率   滚动市现率  市净率
        self.file_name=file_name
        self.code_id=code_id
        self.code_id=self.code_stanard(1)
        if  os.path.exists(self.file_name):
            pass
        else:
            time_create= time.strftime('%Y%m%d%H%M%S',time.localtime(time.time()))
            rs = bs.query_history_k_data_plus(self.code_id,
                "date,code,close,peTTM,pbMRQ,psTTM,pcfNcfTTM",
                start_date=self.start_date, end_date=self.end_date, 
                frequency="d", adjustflag="3")
            #print('query_history_k_data_plus respond error_code:'+rs.error_code)
        # print('query_history_k_data_plus respond  error_msg:'+rs.error_msg)

            #### 打印结果集 ####
            result_list = []
            while (rs.error_code == '0') & rs.next():
                # 获取一条记录，将记录合并在一起
                result_list.append(rs.get_row_data())
            result = pd.DataFrame(result_list, columns=rs.fields)
            
            #### 结果集输出到csv文件 ####
            result.to_csv(self.file_name, encoding="gbk", index=False)
            #print('successful')
    def quotes_none_to_other(self,rootdir):#将新浪财经的数据中None的数据转换为-9999
        self.rootdir=rootdir
        list = os.listdir(self.rootdir) #列出文件夹下所有的目录与文件
        for i in range(0,len(list)):
            path = os.path.join(rootdir,list[i])
            if os.path.isfile(path):
                df=pd.read_csv(path,encoding='GBK',index_col=False)
                df.replace('None', -9999, inplace=True)
                df.to_csv(path,encoding='GBK')
    def merge(self):
        eng = matlab.engine.start_matlab()#可以为所欲为的调用matlab内置函数
        eng.addpath(eng.genpath((nfsysu_stock_upadate.__file__).replace('\\__init__.py','')))
        eng.stockQFQ()
        eng.peTTM()
        time_now = time.strftime('%Y%m%d',time.localtime(time.time()))
        self.file_name='sh.csv'
        self.url='http://quotes.money.163.com/service/chddata.html?code=0000001&start=19900101&end='+str(time_now)+'&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;VOTURNOVER;VATURNOVER'
        self.downloadFile()
        self.file_name='sz.csv'
        self.url='http://quotes.money.163.com/service/chddata.html?code=1399001&start=19900101&end='+str(time_now)+'&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;VOTURNOVER;VATURNOVER'
        self.downloadFile()
        eng.oo_stockQFQ_update_every_day()
        eng.Data_merging()
        
    
            
          
    