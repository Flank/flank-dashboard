#!/usr/bin/env bash
set -euxo pipefail

mkdir -p build
pub get
dart2native bin/main.dart -o build/ci_integrations
