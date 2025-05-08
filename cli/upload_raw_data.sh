#!/bin/bash

# === Resolve script path ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# === Configuration ===
RAW_BUCKET="lab1-raw-data-david/patient-data"
CSV_FILE="$SCRIPT_DIR/../data/realistic_patient_data_10k.csv"
KEY_ID_FILE="$SCRIPT_DIR/../kms/last-created-key-id.txt"
AWS_REGION="us-east-1"

# === Validate key file exists ===
if [[ ! -f "$KEY_ID_FILE" ]]; then
  echo "❌ KMS key ID file not found: $KEY_ID_FILE"
  echo "💡 Did you run create_kms_key.sh?"
  exit 1
fi

# === Validate CSV file exists ===
if [[ ! -f "$CSV_FILE" ]]; then
  echo "❌ CSV file not found: $CSV_FILE"
  exit 1
fi

# === Build full KMS ARN ===
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
KEY_ID=$(cat "$KEY_ID_FILE")
KMS_ARN="arn:aws:kms:$AWS_REGION:$ACCOUNT_ID:key/$KEY_ID"

# === Upload with SSE-KMS encryption ===
echo "🔐 Uploading $CSV_FILE to s3://$RAW_BUCKET/ with KMS encryption..."
aws s3 cp "$CSV_FILE" "s3://$RAW_BUCKET/" \
  --sse aws:kms \
  --sse-kms-key-id "$KMS_ARN"

echo "✅ Upload completed with encryption using:"
echo "   $KMS_ARN"