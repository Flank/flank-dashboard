#!/usr/bin/env bash
set -euo pipefail

cd .metrics/buildkite
curl -o ci_integrations -k https://github.com/platform-platform/monorepo/releases/download/ci_integrations-snapshot/ci_integrations_linux -L
chmod a+x ci_integrations
eval "echo \"$(sed 's/"/\\"/g' ci_integrations_config.yml)\"" >> integration.yml
./ci_integrations sync --config-file integration.yml
