import sys
import json 
from report_exception import report 

try:
  call_sets = json.load(sys.stdin) 
except Exception as err: 
  report(err)
  sys.exit(1)  

for call_set in call_sets: 
  print('{},{},{}'.format(call_set['filenameStem'], call_set['filenameSuffix'], call_set['directory']))
