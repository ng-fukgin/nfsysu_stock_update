import matlab
import matlab.engine
class Detect:
    def __init__(self,filename):
        self.filename=filename
    def detect(self):
        eng = matlab.engine.start_matlab()#����Ϊ����Ϊ�ĵ���matlab���ú���
        return eng.detect(self.filename)
    