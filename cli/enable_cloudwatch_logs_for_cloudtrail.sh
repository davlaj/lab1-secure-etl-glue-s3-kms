#!/bin/bash

# VARIABLES
TRAIL_NAME="lab1-cloudtrail"
LOG_GROUP_NAME="/aws/cloudtrail/lab1"
ROLE_NAME="CloudTrail_CloudWatchLogs_Role"
POLICY_NAME="CloudTrail_CloudWatchLogs_Policy"
AWS_REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Create CloudWatch log group
echo "Creating CloudWatch log group: $LOG_GROUP_NAME..."
aws logs create-log-group \
  --log-group-name "$LOG_GROUP_NAME" \
  --region "$AWS_REGION" 2>/dev/null || echo "Log group already exists"

# Create IAM role for CloudTrail to push to CloudWatch Logs
echo "Creating IAM role: $ROLE_NAME..."
aws iam create-role \
  --role-name "$ROLE_NAME" \
  --assume-role-policy-document file://iam/cloudtrail-trust-policy.json \
  --description "Allows CloudTrail to send logs to CloudWatch Logs" 2>/dev/null || echo "Role already exists"

# Attach permissions policy to the role
aws iam put-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-name "$POLICY_NAME" \
  --policy-document file://iam/cloudtrail-role-policy.json

# Update the CloudTrail trail to use CloudWatch Logs
echo "Updating CloudTrail to log to CloudWatch Logs group..."
ROLE_ARN=$(aws iam get-role --role-name "$ROLE_NAME" --query 'Role.Arn' --output text)

aws cloudtrail update-trail \
  --name "$TRAIL_NAME" \
  --cloud-watch-logs-log-group-arn "arn:aws:logs:$AWS_REGION:$ACCOUNT_ID:log-group:$LOG_GROUP_NAME" \
  --cloud-watch-logs-role-arn "$ROLE_ARN"

echo "✅ CloudTrail now delivers logs to CloudWatch Logs group $LOG_GROUP_NAME."