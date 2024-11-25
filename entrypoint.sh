#!/bin/sh

set -e

# Ensure required environment variables are set
if [ -z "$AWS_S3_BUCKET" ]; then
  echo "ERROR: AWS_S3_BUCKET is not set. Please specify the S3 bucket name."
  exit 1
fi

# Default to us-east-1 if AWS_REGION is not set
if [ -z "$AWS_REGION" ]; then
  echo "AWS_REGION is not set. Defaulting to 'us-east-1'."
  AWS_REGION="us-east-1"
fi

# Override default AWS endpoint if user sets AWS_S3_ENDPOINT
if [ -n "$AWS_S3_ENDPOINT" ]; then
  ENDPOINT_APPEND="--endpoint-url $AWS_S3_ENDPOINT"
else
  ENDPOINT_APPEND=""
fi

# Perform S3 sync
echo "Starting S3 sync..."
aws s3 sync "${SOURCE_DIR:-.}" "s3://${AWS_S3_BUCKET}/${DEST_DIR}" \
  --no-progress \
  ${ENDPOINT_APPEND} "$@"

if [ $? -eq 0 ]; then
  echo "S3 sync completed successfully."
else
  echo "ERROR: S3 sync failed."
  exit 1
fi
