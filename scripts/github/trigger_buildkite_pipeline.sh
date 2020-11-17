#!/usr/bin/env bash
set -euo pipefail

curl -X POST "https://api.buildkite.com/v2/organizations/$ORGANIZATION_SLUG/pipelines/$PIPELINE_SLUG/builds" \
            -d '{
              "commit": "'$GITHUB_SHA'",
              "branch": "master"
            }' \
            -H "Authorization: Bearer $BUILDKITE_TOKEN"
