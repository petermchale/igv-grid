import sys
import json 

try: 
  tracks = json.load(sys.stdin) 
except Exception as err:
  print('Input json file not properly formatted!', file=sys.stderr)
  print(err, file=sys.stderr)
  sys.exit(1)  

for track in tracks:
  print('{},{},{}'.format(
    track['url'], 
    track['indexURL'], 
    track['directory']
  ))