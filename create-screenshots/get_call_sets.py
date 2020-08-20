import sys
import json 

call_sets = json.load(sys.stdin) 

for call_set in call_sets: 
  print('{},{},{}'.format(call_set['filenameStem'], call_set['filenameSuffix'], call_set['directory']))
