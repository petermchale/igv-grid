import sys
import json 
from report_exception import report 

try:
  reference = json.load(sys.stdin) 
except Exception as err: 
  report(err)
  sys.exit(1)    

print('{},{}'.format(reference['chromosomeSizes'], reference['directory']))
