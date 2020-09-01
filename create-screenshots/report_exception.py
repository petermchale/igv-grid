from colorama import init as colorama_init
from colorama import Fore, Style
import sys 

colorama_init()

def error(text):
  print(Fore.RED + text + Style.RESET_ALL, file=sys.stderr)

def info(text): 
  print(Fore.CYAN + text + Style.RESET_ALL, file=sys.stderr)

# input is assumed to be of type JSONDecodeError
def report(err): 
  # pylint: disable=E1101
  info(err.doc)
  error(err.msg)
  error('Got "{}" at line {} and column {}'.format(err.doc[err.pos], err.lineno, err.colno))
