import argparse
import csv
import sys
import re

parser = argparse.ArgumentParser(description="dnsrecon cvs file parser")
parser.add_argument("-f", help="cvs file path")

args = parser.parse_args()
file_result = ""

if args.f is None:
    print("file not found")
    exit(0)

with open(args.f, mode="r", newline='') as file:
    csv_reader = csv.reader(file)
    next(csv_reader)
    for row in csv_reader:
        print(f"{row[2]} {row[3]}")
