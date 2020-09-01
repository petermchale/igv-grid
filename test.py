from colorama import init as colorama_init
from colorama import Fore, Style

colorama_init()
def red(text): 
  print(Fore.RED + text + Style.RESET_ALL)

red('hello peter')

from termcolor import colored, cprint

cprint('Hello, World!', 'green')

import sys 
cprint("Attention!", 'red', attrs=['bold'], file=sys.stderr)
cprint("Attention!", 'red', file=sys.stderr)


