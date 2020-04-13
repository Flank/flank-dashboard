#!/usr/bin/env bash
set -euxo pipefail

mkdir -p build
pub get
pub run test test --coverage build/coverage/
format_coverage --packages=.packages -i build/coverage/ -o build/coverage.lcov --lcov
genhtml -o build/coverage-html build/coverage.lcov