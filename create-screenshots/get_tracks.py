import sys
import json 

tracks = json.load(sys.stdin) 

for track in tracks:
  print('{},{},{}'.format(
    track['url'], 
    track['indexURL'], 
    track['directory']
  ))