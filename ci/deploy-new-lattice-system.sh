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
      "url": "$INFRASTRUCTURE_ADDRESS",
      "auth": {
        "bearerToken": "$INFRASTRUCTURE_BEARER_TOKEN"
      }
    }
  }
}
EOT

cp linux-latticectl-binary/latticectl_* latticectl
chmod +x latticectl

./latticectl deploy --system infrastructure --version $(cat ./system-definition-repo/.git/ref) --config config.json
