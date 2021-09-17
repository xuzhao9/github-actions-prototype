#!/usr/bin/python3
import subprocess

print("This is an output.")

# Set the environment variable
command = 'echo TORCHBENCH_BISECT="YES" >> $GITHUB_ENV'
subprocess.check_call(command, shell=False)

