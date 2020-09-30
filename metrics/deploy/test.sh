#!/usr/bin/env bash
set -euxo pipefail

pub get
pub run test test/ --concurrency=1 -r expanded
