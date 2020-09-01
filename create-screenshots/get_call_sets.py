import sys
import json 

try:
  call_sets = json.load(sys.stdin) 
except Exception as err: 
  print('Input json file not properly formatted!', file=sys.stderr)
  print(err, file=sys.stderr)
  sys.exit(1)  

for call_set in call_sets: 
  print('{},{},{}'.format(call_set['filenameStem'], call_set['filenameSuffix'], call_set['directory']))
