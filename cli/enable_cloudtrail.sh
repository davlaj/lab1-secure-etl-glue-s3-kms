#!/bin/bash

# VARIABLES
TRAIL_NAME="lab1-cloudtrail"
AWS_REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET_NAME="cloudtrail-logs-$ACCOUNT_ID"

# Create CloudTrail trail
echo "Creating CloudTrail trail: $TRAIL_NAME..."
aws cloudtrail create-trail \
  --name "$TRAIL_NAME" \
  --s3-bucket-name "$BUCKET_NAME" \
  --is-multi-region-trail \
  --enable-log-file-validation \
  --output table

# Start logging
echo "Starting CloudTrail logging..."
aws cloudtrail start-logging --name "$TRAIL_NAME"

echo "✅ CloudTrail trail '$TRAIL_NAME' enabled and logging to bucket '$BUCKET_NAME'."s