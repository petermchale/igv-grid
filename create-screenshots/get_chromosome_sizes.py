import sys
import json 

try:
  reference = json.load(sys.stdin) 
except Exception as err: 
  print('Input json file not properly formatted!', file=sys.stderr)
  print(err, file=sys.stderr)
  sys.exit(1)    

print('{},{}'.format(reference['chromosomeSizes'], reference['directory']))
