#!/bin/bash

# VARIABLES
AWS_REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET_NAME="cloudtrail-logs-$ACCOUNT_ID"
LOGGING_BUCKET_POLICY_FILE="cloudtrail-bucket-policy.json"

# Create the S3 bucket
echo "Creating CloudTrail logs bucket: $BUCKET_NAME in $AWS_REGION..."
if [ "$AWS_REGION" == "us-east-1" ]; then
  aws s3api create-bucket --bucket "$BUCKET_NAME"
else
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --create-bucket-configuration LocationConstraint="$AWS_REGION"
fi

# Block public access (best practice)
aws s3api put-public-access-block \
  --bucket "$BUCKET_NAME" \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# Create and apply bucket policy to allow CloudTrail to write logs
cat > $LOGGING_BUCKET_POLICY_FILE <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": { "Service": "cloudtrail.amazonaws.com" },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::$BUCKET_NAME"
    },
    {
      "Sid": "AWSCloudTrailWrite",
      "Effect": "Allow",
      "Principal": { "Service": "cloudtrail.amazonaws.com" },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::$BUCKET_NAME/AWSLogs/$ACCOUNT_ID/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
EOF

aws s3api put-bucket-policy \
  --bucket "$BUCKET_NAME" \
  --policy file://$LOGGING_BUCKET_POLICY_FILE

echo "✅ Bucket $BUCKET_NAME created and configured for CloudTrail logs."