# AWS Infrastructure Snapshot Comparison Script
# Author: Khushi Mehta

This Bash script helps compare JSON snapshot files of AWS resources across two dates to detect infrastructure changes such as additions, deletions, or modifications.

---

## Features

- Take snapshot of AWS services 
- Compare snapshots of AWS services (EC2, S3, IAM, RDS, etc.)
- View differences using `diff` or `colordiff` (if installed)
- Highlights added/removed lines with a summary
- Supports:
  - Full comparison (all services)
  - Targeted comparison (specific service)

---

## Directory Structure

infra-snapshot-tracker/
├── README.md
├── diffs
├── scripts
│   ├── compare.sh
│   └── snapshot.sh
├── snapshots
└── tracker.sh

---

## Prerequisites

- **Bash shell**
- **AWS CLI** configured (`aws configure`)
- [`jq`](https://stedolan.github.io/jq/) for JSON formatting
- Optional: `colordiff` for colorized output

---

## Install Dependencies

- Ubuntu/Debian:
sudo apt update
sudo apt install jq colordiff

- RHEL:
sudo yum install jq colordiff

---

# Usage: 

## Take Snapshots based on regions:
bash infra-snapshot-tracker/scripts/snapshot.sh

## Compare all Services:
infra-snapshot-tracker/scripts/compare.sh <old_date-region> <new_date-region>

## Compare specific service: 
infra-snapshot-tracker/scripts/compare.sh <service> <old_date-region> <new_date-region>

## Compare multiple services:
infra-snapshot-tracker/scripts/compare.sh <service1> <service2> <service3>... <old_date-region> <new_date-region>

# Run tracker.sh file to capture the snapshots and to get the guidance command to compare the snapshots. 
infra-snapshot-tracker/tracker.sh

---

## Supported Services:

ec2
s3
security-group
iam-users
rds
dynamodb
lambda
ebs
cloudfront
sns
route53
vpc
elb
cloudformation


