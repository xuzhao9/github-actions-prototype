#!/usr/bin/python3
import subprocess
import os
from pathlib import Path

perf_signal_report = """
TorchBench {version} CI detected a performance signal between commit {start_commit} and {end_commit}.

Affected tests:
{tests_report}

Running the bisection job:
{bisection_job_link}

cc @xuzhao9 @bitfort
"""

print("This is an output.")

if "GITHUB_ENV" in os.environ:
    fname = os.environ["GITHUB_ENV"]
    content = "TORCHBENCH_BISECT='yes'\n"
    with open(fname, 'a') as fo:
        fo.write(content)

# Generate path directory
directory = "benchmark-result"
Path(directory).mkdir(exist_ok=True)
# Generate the bug report
report_file = os.path.join(directory, "report.md")
with open(report_file, 'w') as fr:
    fr.write(perf_signal_report)
    
