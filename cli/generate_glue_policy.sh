#!/bin/bash

# === Get the directory of the script, no matter where it's called from ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# === User-defined values ===
RAW_BUCKET="lab1-raw-data-david"
PROCESSED_BUCKET="lab1-processed-data-david"
AWS_REGION="us-east-1"

# === Get account ID dynamically ===
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# === Get previously created KMS Key ID ===
KEY_ID=$(cat "$SCRIPT_DIR/../kms/last-created-key-id.txt")

# === Construct full KMS ARN ===
KMS_ARN="arn:aws:kms:$AWS_REGION:$AWS_ACCOUNT_ID:key/$KEY_ID"

echo "Generating Glue role policy using:"
echo "- RAW_BUCKET: $RAW_BUCKET"
echo "- PROCESSED_BUCKET: $PROCESSED_BUCKET"
echo "- KMS ARN: $KMS_ARN"

# === Define paths ===
TEMPLATE_FILE="$SCRIPT_DIR/../iam/glue-role-policy.template.json"
OUTPUT_FILE="$SCRIPT_DIR/../iam/glue-role-policy.final.json"

# === Ensure output directory exists ===
mkdir -p "$(dirname "$OUTPUT_FILE")"

# === Substitute placeholders in template ===
sed \
  -e "s|{{RAW_BUCKET}}|$RAW_BUCKET|g" \
  -e "s|{{PROCESSED_BUCKET}}|$PROCESSED_BUCKET|g" \
  -e "s|{{KMS_ARN}}|$KMS_ARN|g" \
  "$TEMPLATE_FILE" > "$OUTPUT_FILE"

echo "✅ glue-role-policy.final.json generated successfully at: $OUTPUT_FILE"
