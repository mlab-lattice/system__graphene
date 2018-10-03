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

cp linux-latticectl-binary/latticectl_* latticectl
chmod +x latticectl

./latticectl deploy --system infrastructure --version $(cat ./system-definition-repo/.git/ref) --config config.json
