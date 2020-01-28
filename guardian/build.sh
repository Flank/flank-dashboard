#!/usr/bin/env bash
set -euxo pipefail

mkdir build
pub get
dart2native bin/main.dart -o build/guardian
