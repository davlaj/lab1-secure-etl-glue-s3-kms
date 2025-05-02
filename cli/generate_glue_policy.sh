#!/bin/bash

RAW_BUCKET="lab1-raw-data-david"
PROCESSED_BUCKET="lab1-processed-data-david"
KMS_ARN="arn:aws:kms:us-east-1:123456789012:key/your-key-id"  # Replace after key creation

# Substitute variables in template
sed \
  -e "s|{{RAW_BUCKET}}|$RAW_BUCKET|g" \
  -e "s|{{PROCESSED_BUCKET}}|$PROCESSED_BUCKET|g" \
  -e "s|{{KMS_ARN}}|$KMS_ARN|g" \
  ../iam/glue-role-policy.template.json > ../iam/glue-role-policy.final.json

echo "Generated final policy: ../iam/glue-role-policy.final.json"
