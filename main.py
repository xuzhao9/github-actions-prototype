#!/usr/bin/python3
import subprocess
import os

print("This is an output.")

fname = os.environ["GITHUB_ENV"]
content = "TORCHBENCH_BISECT='yes'\n"

with open(fname, 'a') as fo:
    fo.write(content)
