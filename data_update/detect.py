import nfsysu_stock_upadate
try:
    import matlab
    import matlab.engine
except:
    raise Exception(r"请先配置matlab使得python能够调用  \n  https://ng-fukgin.gitee.io/%E6%95%99%E7%A8%8B/2022/01/25/MATLAB_Engine_for_Python/")
class Detect:
    def __init__(self,filename):
        self.filename=filename
    def detect(self,nargout=2):
        self.nargout=nargout
        eng = matlab.engine.start_matlab()#可以为所欲为的调用matlab内置函数
        eng.addpath(eng.genpath((nfsysu_stock_upadate.__file__).replace('\\__init__.py','')))
 
        return eng.detect(self.filename,nargout=self.nargout)
    