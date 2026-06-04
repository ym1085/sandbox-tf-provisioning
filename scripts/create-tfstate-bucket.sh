#!/bin/bash

set -euo pipefail
read -p "BUCKET NAME : " BUCKET
read -p "REGION : " REGION

if [[ -z "${BUCKET}" ]]; then
  echo "BUCKET NAME is empty"
  exit 1
fi

if [[ -z "${REGION}" ]]; then
  echo "REGION is empty"
  exit 1
fi

aws s3api create-bucket \
  --bucket "$BUCKET" \
  --region "$REGION" \
  --create-bucket-configuration LocationConstraint="$REGION"

aws s3api put-bucket-versioning \
  --bucket "$BUCKET" \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket "$BUCKET" \
  --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

aws s3api put-public-access-block \
  --bucket "$BUCKET" \
  --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
