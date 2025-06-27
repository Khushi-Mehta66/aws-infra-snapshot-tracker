#!/bin/bash

# === Configuration ===
SERVICES=("ec2" "s3" "security-group" "iam-users" "rds" "dynamodb" "lambda" "ebs" "cloudfront" "sns" "route53" "vpc" "elb" "cloudformation")
SNAPSHOT_DIR="/home/ec2-user/infra-snapshot-tracker/snapshots/"
DIFF_DIR="/home/ec2-user/infra-snapshot-tracker/diffs"

# === Prompt AWS Region ===

#read -p "Enter AWS Region (e.g., us-east-1): " REGION

# === Validate AWS Region ===
#if ! aws ec2 describe-availability-zones --region "$REGION" > /dev/null 2>&1; then
#   echo "Invalid AWS region or not accessible: $REGION"
#   exit 1
#fi

# === Create Diff Directory ===
mkdir -p "$DIFF_DIR"

# === Help Message ===
usage() {
    echo "Usage:"
    echo "  $0 <old_date> <new_date>                                # Compare all services"
    echo "  $0 <service1> <service2> ... <old_date> <new_date>      # Compare selected services"
    exit 1
}

# === Comparison Function ===
compare_service() {
    local SERVICE=$1
    local OLD_DATE=$2
    local NEW_DATE=$3

    local OLD_FILE="$SNAPSHOT_DIR/${SERVICE}-${OLD_DATE}.json"
    local NEW_FILE="$SNAPSHOT_DIR/${SERVICE}-${NEW_DATE}.json"
    local DIFF_FILE="$DIFF_DIR/diff-${SERVICE}-${OLD_DATE}_vs_${NEW_DATE}.txt"

    echo "============================================================="
    echo "Comparing $SERVICE:"
    echo " OLD: $OLD_FILE"
    echo " NEW: $NEW_FILE"

    # Ensure snapshot files exist
    if [[ ! -f "$OLD_FILE" || ! -f "$NEW_FILE" ]]; then
        echo "Snapshot files not found! Skipping $SERVICE"
        return
    fi

    # Compare and save diff
    diff <(jq -S . "$OLD_FILE") <(jq -S . "$NEW_FILE") > "$DIFF_FILE"

    if [[ -s "$DIFF_FILE" ]]; then
        echo "Changes found. Saved to: $DIFF_FILE"
        if command -v colordiff > /dev/null; then
            colordiff < "$DIFF_FILE" | less -R
        else
            cat "$DIFF_FILE" | less
        fi
        # Summary
        ADDED=$(grep '^>' "$DIFF_FILE" | wc -l)
        REMOVED=$(grep '^<' "$DIFF_FILE" | wc -l)
        echo "Summary: $ADDED additions, $REMOVED deletions"
    else
        echo "No changes found in $SERVICE"
        rm -f "$DIFF_FILE"
    fi
}

# === MAIN LOGIC ===

if [[ $# -eq 2 ]]; then
    OLD_DATE=$1
    NEW_DATE=$2
    echo "Comparing ALL services from $OLD_DATE to $NEW_DATE"
    for svc in "${SERVICES[@]}"; do
        compare_service "$svc" "$OLD_DATE" "$NEW_DATE"
    done

elif [[ $# -ge 3 ]]; then
    OLD_DATE=${@: -2:1}
    NEW_DATE=${@: -1}
    SELECTED_SERVICES=("${@:1:$#-2}")

    for svc in "${SELECTED_SERVICES[@]}"; do
        if [[ ! " ${SERVICES[*]} " =~ " $svc " ]]; then
            echo "Unsupported service: $svc"
            echo "Supported: ${SERVICES[*]}"
            exit 1
        fi
    done

    echo "Comparing SELECTED services: ${SELECTED_SERVICES[*]}"
    echo "From $OLD_DATE to $NEW_DATE"
    for svc in "${SELECTED_SERVICES[@]}"; do
        compare_service "$svc" "$OLD_DATE" "$NEW_DATE"
    done

else
    usage
fi

