#!/bin/bash

# === Resolve paths ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEY_FILE="$SCRIPT_DIR/../kms/last-created-key-id.txt"

# === Check if key already exists ===
if [[ -f "$KEY_FILE" ]]; then
  EXISTING_KEY_ID=$(cat "$KEY_FILE")
  echo "⚠️  A KMS key is already defined: $EXISTING_KEY_ID"
  echo "💡 To create a new key, delete: $KEY_FILE"
  exit 0
fi

# === Create new symmetric KMS key ===
KEY_ID=$(aws kms create-key \
  --description "KMS key for Lab 1 ETL data encryption" \
  --key-usage ENCRYPT_DECRYPT \
  --origin AWS_KMS \
  --query 'KeyMetadata.KeyId' \
  --output text)

echo "🆕 Created KMS Key: $KEY_ID"

# === Enable key rotation ===
aws kms enable-key-rotation --key-id "$KEY_ID"
echo "🔁 Key rotation enabled for $KEY_ID"

# === Store key ID to file ===
mkdir -p "$(dirname "$KEY_FILE")"
echo "$KEY_ID" > "$KEY_FILE"
echo "✅ Saved KMS key ID to $KEY_FILE"
