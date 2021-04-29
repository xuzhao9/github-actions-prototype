"""
Generate a torchbench test report from a file containing the PR body.
Currently, only supports specifying model names

Testing environment:
- Intel Xeon 8259CL @ 2.50 GHz, 24 Cores with disabled Turbo and HT
- Nvidia Tesla T4
- Nvidia Driver 450.51.06
- CUDA 10.2
"""

import os
import argparse

CUDA_VERSION = "cu102"
OUTPUT_DIR: str = os.path.join(os.environ("HOME"), ".torchbench", "pr", os.environ("GITHUB_RUN_ID"))

def extract_models_from_pr(torchbench_path, prbody_file):
    out = ""
    model_list = []
    MAGIC_PREFIX = "RUN-TORCHBENCH:"
    with open(prbody_file, "r") as pf:
        magic_lines = filter(lambda x: x.startswith(MAGIC_PREFIX), pf.lines())
        if magic_lines:
            model_list = list(map(lambda x: x.strip(), magic_lines[0][len(MAGIC_PREFIX)].split(",")))
    # Sanity check: make sure all the user specified models exist in torchbench repository
    full_model_list = os.listdir(os.path.join(torchbench_path, "torchbenchmark", "models"))
    for m in model_list:
        if not m in full_model_list:
            print(f"The model {m} you specified does not exist in TorchBench suite. Please double check.")
            return out
    if model_list:
        out = " or ".join(model_list)
        out = f"({out})"
    return out

def create_conda_environment():
    pass

def destroy_conda_environment():
    pass

def install_dependencies():
    # Install the latest nightly torchtext, torchvision, and torchaudio wheels
    command = "pip install --pre "

# Use pip to uninstall a package
def uninstall_package(package: str):
    command = f"pip uninstall -y {package}"

# Analyze the raw TorchBench result and output human-friendly version to a file
def analyze_result():
    pass

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Run TorchBench tests based on PR body')
    parser.add_argument('pr-num', required=True, type=str,
                        help="The Pull Request number")
    parser.add_argument('pr-body', required=True, type=argparse.FileType('r'),
                        help="The file that contains body of a Pull Request")
    parser.add_argument('torchbench-path', required=True, type=str, help="Path to TorchBench repository")
    args = parser.parse_args()
    torchbench_filter = extract_models_from_pr(args.torchbench_path, args.pr_body)
    if not torchbench_filter:
        return
    print(f"Ready to run TorchBench with benchmark filter {torchbench_filter}. Result will be saved in the directory: {OUTPUT_DIR}.")
    create_conda_environment(args.pr_num)
    # Install the base pytorch
    # Install other dependencies
    # Uninstall the base pytorch
    # Install the tip pytorch
    # Install other dependencies
    # Uninstall the tip pytorch
    # Destroy conda environment
    destroy_conda_environment(args.pr_num)
    # Output the PR report to file
    
