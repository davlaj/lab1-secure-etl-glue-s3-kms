#!/bin/bash

# Create a symmetric KMS key and automatically enable key rotation

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
