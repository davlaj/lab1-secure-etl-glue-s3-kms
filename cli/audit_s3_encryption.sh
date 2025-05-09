#!/bin/bash
# ============================================================================
# Script: audit_s3_encryption.sh
# Purpose: Audit all S3 buckets to verify encryption and policy enforcement
#
# This script performs the following checks for each bucket:
#   - Whether default encryption (SSE-KMS or SSE-S3) is enabled
#   - Whether the bucket policy enforces encryption on uploads (PutObject)
#   - Flags buckets that may allow unencrypted data at rest
#
# Usage:
#   chmod +x cli/audit_s3_encryption.sh
#   ./cli/audit_s3_encryption.sh
#
# Output:
#   - ✅ or ❌ status per bucket
#   - Summary of encryption enforcement
#
# Dependencies:
#   - AWS CLI must be configured with read access to all buckets
#
# Author: David Lajeunesse
# ============================================================================

echo "🔍 Auditing all S3 buckets for encryption and unencrypted upload risk..."
BUCKETS=$(aws s3api list-buckets --query 'Buckets[*].Name' --output text)

for BUCKET in $BUCKETS; do
  echo -e "\n🪣 Checking bucket: $BUCKET"

  # Check if default encryption is enabled
  if aws s3api get-bucket-encryption --bucket "$BUCKET" >/dev/null 2>&1; then
    echo "✅ Default encryption is ENABLED"
  else
    echo "❌ Default encryption is NOT enabled"
  fi

  # Check for dangerous bucket policy allowing unencrypted upload
  POLICY=$(aws s3api get-bucket-policy --bucket "$BUCKET" --query 'Policy' --output text 2>/dev/null)
  if echo "$POLICY" | grep -q '"s3:PutObject"'; then
    if echo "$POLICY" | grep -q 's3:x-amz-server-side-encryption'; then
      echo "✅ Bucket policy enforces encryption on PutObject"
    else
      echo "⚠️ Bucket policy allows uploads WITHOUT enforcing encryption"
    fi
  else
    echo "ℹ️ No explicit PutObject policy found (likely controlled by IAM)"
  fi
done

echo -e "\n🧾 Done. Review buckets marked ❌ or ⚠️ for encryption compliance."