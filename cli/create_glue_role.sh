#!/bin/bash

ROLE_NAME="Lab1GlueRole"

# Create IAM role for AWS Glue
aws iam create-role \
  --role-name "$ROLE_NAME" \
  --assume-role-policy-document file://../iam/glue-trust-policy.json \
  --description "IAM role for Glue Lab 1 ETL pipeline"

echo "Created IAM role: $ROLE_NAME"

# Attach inline policy for S3 and KMS access
aws iam put-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-name GlueS3KMSSecurityPolicy \
  --policy-document file://../iam/glue-role-policy.json

echo "Attached inline policy to $ROLE_NAME"
