#!/usr/bin/python3
import subprocess
import os

print("This is an output.")

e = os.environ["GITHUB_ENV"]
print(e)
e = e + "\n" + 'TORCHBENCH_BISECT="YES"' + "\n"
os.environ["GITHUB_ENV"] = e
print(e)

