import sys
import json 
from report_exception import report 

try: 
  tracks = json.load(sys.stdin) 
except Exception as err:
  report(err)
  sys.exit(1)  

for track in tracks:
  print('{},{},{}'.format(
    track['url'], 
    track['indexURL'], 
    track['directory']
  ))