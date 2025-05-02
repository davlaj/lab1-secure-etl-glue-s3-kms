#!/bin/bash

# Get script path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Paths
TRUST_POLICY="$SCRIPT_DIR/../iam/glue-trust-policy.json"
ROLE_POLICY="$SCRIPT_DIR/../iam/glue-role-policy.final.json"

ROLE_NAME="Lab1GlueRole"
POLICY_NAME="GluePolicy"

# Create IAM role with trust policy
aws iam create-role \
  --role-name "$ROLE_NAME" \
  --assume-role-policy-document file://"$TRUST_POLICY"

echo "Created IAM role: $ROLE_NAME"

# Attach inline policy
aws iam put-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-name "$POLICY_NAME" \
  --policy-document file://"$ROLE_POLICY"

echo "Attached inline policy to $ROLE_NAME"
