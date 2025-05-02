#!/bin/bash

KEY_ID=$(aws kms create-key \
  --description "KMS key for Lab 1 ETL data encryption" \
  --key-usage ENCRYPT_DECRYPT \
  --origin AWS_KMS \
  --query 'KeyMetadata.KeyId' \
  --output text)

echo "Created KMS Key: $KEY_ID"

# Enable key rotation
aws kms enable-key-rotation --key-id "$KEY_ID"
echo "Key rotation enabled for $KEY_ID"

# Create directory if it doesn't exist
mkdir -p ../kms

# Save key id to file
echo "$KEY_ID" > ../kms/last-created-key-id.txt
