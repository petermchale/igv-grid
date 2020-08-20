import sys
import json 

reference = json.load(sys.stdin) 

print('{},{}'.format(reference['chromosomeSizes'], reference['directory']))
