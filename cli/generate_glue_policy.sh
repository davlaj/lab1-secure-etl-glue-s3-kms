#!/bin/bash

RAW_BUCKET="lab1-raw-data-david"
PROCESSED_BUCKET="lab1-processed-data-david"
KEY_ID=$(cat ../kms/last-created-key-id.txt)
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
KMS_ARN="arn:aws:kms:$AWS_REGION:$AWS_ACCOUNT_ID:key/$KEY_ID"

# Substitute into template
sed \
  -e "s|{{RAW_BUCKET}}|$RAW_BUCKET|g" \
  -e "s|{{PROCESSED_BUCKET}}|$PROCESSED_BUCKET|g" \
  -e "s|{{KMS_ARN}}|$KMS_ARN|g" \
  ../iam/glue-role-policy.template.json > ../iam/glue-role-policy.final.json

echo "Generated glue-role-policy.final.json using KMS Key $KEY_ID"
