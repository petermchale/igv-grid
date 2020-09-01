import sys
import json 
from colorama import init as colorama_init
from colorama import Fore, Style

colorama_init()

def red(text):
  print(Fore.RED + text + Style.RESET_ALL, file=sys.stderr)

try: 
  tracks = json.load(sys.stdin) 
except Exception as err:
  red('Input json file not properly formatted!')
  red(err)
  sys.exit(1)  

for track in tracks:
  print('{},{},{}'.format(
    track['url'], 
    track['indexURL'], 
    track['directory']
  ))