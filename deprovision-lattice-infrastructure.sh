#!/usr/bin/env bash

set -o errexit
set -o pipefail

if [ -z "$AWS_ACCESS_KEY_ID" ] && [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo 'AWS creds not set. Please set the "AWS_ACCESS_KEY_ID" and "AWS_SECRET_ACCESS_KEY" environment variables.'
  exit 1
fi

# Do this after checking for AWS creds to give good error message.
set -o nounset

IMAGE_URI=161545394894.dkr.ecr.us-west-2.amazonaws.com/bundled-k8s-util-linux

docker pull $IMAGE_URI

docker run -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY $IMAGE_URI:latest destroy \
  --id lattice-staging-app \
  --cloud-provider AWS \
  --bearer-token $(cat ./infrastructure-bearer-token.txt) \
  --cloud-provider-var=region=us-east-2 \
  --cloud-provider-var=terraform-backend-s3-bucket=laas.dev.staging \
  --cloud-provider-var=terraform-backend-s3-key=lattices.lattice-staging-app/terraform/terraform.tfstate \
  --cloud-provider-var=terraform-backend-s3-bucket-region=us-east-1
