"""
Parse the output of release testing scripts and generate a summary
"""

import argparse
import json
import sys
import yaml
import os
import subprocess

def parse_memory(r, rpath):
    pass

def parse_walltime(r, rpath):
    command = f"grep 'Total time elapsed' {rpath} | cut -d ' ' -f 4"
    out = subprocess.check_output(command, shell=True).decode().strip()
    r["walltime"] = float(out)

def parse_result_dir(output_dir):
    result = dict()
    result_files = ["result.log", "result_mem.log"]
    for f in os.listdir(output_dir):
        p = os.path.join(output_dir, f)
        result[f] = dict()
        parse_walltime(result[f], os.path.join(p, result_files[0]))
        parse_memory(result[f], os.path.join(p, result_files[1]))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output-dir",
                        help="Release testing result dir",
                        required=True)
    parser.add_argument("--output-format",
                        help="format of the output file (json or yaml)",
                        default="json")
    parser.add_argument("--output-file",
                        help="output file name",
                        default="output.json")
    args = parser.parse_args()
    results = parse_result_dir(args.output_dir)
    with open(args.output_file, "w", encoding="utf-8") as f:
        if args.output_format == "json":
            yaml.dump(results, f)
        elif args.output_format == "yaml":
            json.dump(results, f, indent=4)
        else:
            print(f"Unsupported output format: {args.output_format}")
            sys.exit(1)
