#!/bin/bash
#=========================================================================
#This script helps to collect snapshot of different service
# Author: Khushi Mehta
# Version: v0.0.1
#
# This sxript includes the following supported services 
# EC2 
# S3
# Security Groups
# IAM user
# RDS
# DynamDB
# Lambda
# EBS
# CloudFront
# CloudWatch
# SNS
# Route53
# VPC
# ELB
# CloudFormation
#=========================================================================

#Configuration to collect snapshots of different services.

read -p "Enter AWS region: " REGION

#Validate region by checking availability zone 

aws ec2 describe-availability-zones --region "$REGION" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Error: Region not found or invalid region provided"
	exit 1
fi
region=$REGION
DATE=$(date +%F-%H-%M-%S)
SNAPSHOT_DIR="/home/ec2-user/infra-snapshot-tracker/snapshots"

mkdir -p "$SNAPSHOT_DIR"

#EC2 instances
aws ec2 describe-instances --region $REGION > "$SNAPSHOT_DIR/ec2-$DATE.json"

#S3 bucket
aws s3api list-buckets > "$SNAPSHOT_DIR/s3-$DATE.json"

#Security groups
aws ec2 describe-security-groups --region $REGION > "$SNAPSHOT_DIR/security-group-$DATE.json"

#IAM users
aws iam list-users > "$SNAPSHOT_DIR/iam-users-$DATE.json"

#RDS
aws rds describe-db-instances --region $REGION > "$SNAPSHOT_DIR/rds-$DATE.json"

#Dynamodb
aws dynamodb list-tables --region $REGION > "$SNAPSHOT_DIR/dynamodb-$DATE.json"

#lambda
aws lambda list-functions --region $REGION > "$SNAPSHOT_DIR/lambda-$DATE.json"

#EBS
aws ec2 describe-volumes --region $REGION > "$SNAPSHOT_DIR/ebs-$DATE.json"

#CloudFront
aws cloudwatch list-metrics --region $REGION > "$SNAPSHOT_DIR/cloudfront-$DATE.json"

#SNS
aws sns list-topics --region $REGION > "$SNAPSHOT_DIR/sns-$DATE.json"

#Route53
aws route53 list-hosted-zones > "$SNAPSHOT_DIR/route53-$DATE.json"

#VPC
aws ec2 describe-vpcs --region $REGION > "$SNAPSHOT_DIR/vpc-$DATE.json"

#ELB
aws elb describe-load-balancers --region $REGION > "$SNAPSHOT_DIR/elb-$DATE.json"

#CloudFormation
aws cloudformation describe-stacks --region $REGION > "$SNAPSHOT_DIR/cloudformation-$DATE.json"

echo "Snapshots of $region region saved for $DATE"
