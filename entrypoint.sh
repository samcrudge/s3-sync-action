#!/bin/sh

set -e

# Function to handle errors and display meaningful messages
handle_error() {
  echo "Error occurred in script at line: $1"
  exit $2
}

# Trap errors and pass them to the error handler
trap 'handle_error ${LINENO} $?' ERR

# Ensure required environment variables are set
if [ -z "$AWS_S3_BUCKET" ]; then
  echo "ERROR: AWS_S3_BUCKET is not set. Please specify the S3 bucket name."
  exit 1
fi

# Default to us-east-1 if AWS_REGION not set
if [ -z "$AWS_REGION" ]; then
  echo "AWS_REGION not set. Defaulting to 'us-east-1'."
  AWS_REGION="us-east-1"
fi

# Override default AWS endpoint if user sets AWS_S3_ENDPOINT
if [ -n "$AWS_S3_ENDPOINT" ]; then
  ENDPOINT_APPEND="--endpoint-url $AWS_S3_ENDPOINT"
fi

# Log message indicating the use of IAM role
echo "Using IAM role for authentication."

# Perform S3 sync with error handling
echo "Starting S3 sync..."
if ! sh -c "aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${DEST_DIR} \
              --no-progress \
              ${ENDPOINT_APPEND} $*"; then
  echo "ERROR: Failed to sync files to S3 bucket: ${AWS_S3_BUCKET}"
  exit 1
fi

echo "S3 sync completed successfully."

# Clean exit
exit 0
