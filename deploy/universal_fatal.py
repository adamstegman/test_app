#!/usr/bin/env python
import sys
import os
import signal

def write_stdout(s):
   sys.stdout.write(s)
   sys.stdout.flush()
def write_stderr(s):
   sys.stderr.write(s)
   sys.stderr.flush()
def main():
   while 1:
       write_stdout('READY\n')
       line = sys.stdin.readline()
       write_stdout('[universal_fatal] Killing supervisor: ' + line)
       try:
           pidfile = open('/var/run/supervisord.pid','r')
           pid = int(pidfile.readline())
           os.kill(pid, signal.SIGTERM)
       except Exception as e:
           write_stdout('[universal_fatal] Could not kill supervisor: ' + e.strerror + '\n')
       write_stdout('RESULT 2\nOK')
if __name__ == '__main__':
   main()
   import sys
