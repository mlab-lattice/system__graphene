#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

cat <<EOT >> config.json
{
  "currentContext": "c",
  "contexts": {
    "c": {
      "lattice": "$INFRASTRUCTURE_ADDRESS",
      "auth": {
        "legacyApiKey": "$INFRASTRUCTURE_BEARER_TOKEN",
        "bearerToken": null
      }
    }
  }
}
EOT

# FIXME: do not get from S3 but from a resource
wget https://s3-us-east-2.amazonaws.com/lattice-binaries-staging/latticectl_linux_amd64_vv0.1.1-91-gcfdfa70 -O latticectl

chmod +x latticectl

./latticectl build --system infrastructure --version $(cat ./system-definition-repo/.git/ref) --config config.json
