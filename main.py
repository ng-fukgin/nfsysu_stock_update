from sre_parse import CATEGORIES
from unicodedata import category
from data_update.update import Update
from data_update.detect import Detect
import tushare as ts
import time
import nfsysu_stock_upadate
import shutil,os
import warnings
try:
    import matlab
    import matlab.engine
except:
    raise Exception(r"请先配置matlab使得python能够调用  \n  https://ng-fukgin.gitee.io/%E6%95%99%E7%A8%8B/2022/01/25/MATLAB_Engine_for_Python/")
eng = matlab.engine.start_matlab()#可以为所欲为的调用matlab内置函数
def str_to_bool(str):
    return True if str.lower() == 'true' else False
def main():
    eng.addpath(eng.genpath((nfsysu_stock_upadate.__file__).replace('\\__init__.py','')))
    test = ts.get_today_all()#获取今天所有股票
    time_create= time.strftime('%Y-%m-%d',time.localtime(time.time()))#获取今天日期
    time_last_4_day= time.strftime('%Y-%m-%d',time.localtime(time.time()-4*86400))#获取4天前日期,中国股票不交易时间最多是3天
    c=Update(time_last_4_day,time_create)
    for i in test['code']:#下载股票
            code=(i.zfill(6))
            if code.startswith('6'):
                code_id='sh.'+str(code)
            else:
                code_id='sz.'+str(code)
            name='./peTTM'+'/'+code+'.csv'
            
            c.dowload_from_sina(code_id,'test.csv')#下载每只股票
            if os.path.getsize(r'test.csv')>108:#没数据的csv文件是108字节
                break
            
    assert  ( os.path.exists('StockQFQ.mat')),'StockQFQ.mat 文件不存在,请先下载或者添加到当前目录'
    shutil.copyfile('StockQFQ.mat','StockQFQ_backup.mat')
    try:
        shutil.copyfile('StockQFQ_%s.mat'%(time.strftime('%Y',time.localtime(time.time()))),'StockQFQ_%s_backup.mat'%(time.strftime('%Y',time.localtime(time.time()))))
    except:
        pass
    d=Detect('E:/WFJ/test/StockQFQ.mat')
   

    warnings.warn('nfsysu_stock_upadate 将会在后续版本中被移除,请使用nfsysu_stock_update')
    try:
        shutil.rmtree('./quotes/')
    except:
        pass
    os.mkdir('./quotes/')
    try:
        shutil.rmtree('./peTTM/')
    except:
        pass
    os.mkdir('./peTTM/')
    [a,b]=d.detect()
    if str_to_bool(a):#返回的'Ture'/'False'是str类型，要转为bool类型
        time_now = time.strftime('%Y-%m-%d',time.localtime(time.time()))
        page_saving_path =time_now + '.xlsx'   # save path of stock data
        test.to_excel(page_saving_path)
        d=Update(b,time_create)
       
        for i in test['code']:
            code=(i.zfill(6))
            if code.startswith('6'):
                code_id='sh.'+str(code)
            else:
                code_id='sz.'+str(code)
            name='./peTTM'+'/'+code+'.csv'
            
            d.dowload_from_sina(code_id,'./quotes'+'/'+code+'.csv')
            d.dowload_from_baostock(code_id,'./peTTM'+'/'+code+'.csv')
            
        d.quotes_none_to_other('./quotes/')
        d.merge() 
if __name__=='__main__':
    main()