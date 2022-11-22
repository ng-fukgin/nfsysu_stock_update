import matlab
import matlab.engine
class Detect:
    def __init__(self,filename):
        self.filename=filename
    def detect(self):
        eng = matlab.engine.start_matlab()#可以为所欲为的调用matlab内置函数
        return eng.detect(self.filename)
    