#!/usr/bin/env bash
set -euxo pipefail

if test -d "build/coverage"; then 
    rm -rf build/coverage
fi
mkdir -p build/coverage/lcov build/coverage/badge build/coverage/html

pub get
pub run test_coverage

mv coverage/* build/coverage/lcov
rm -rf coverage

if test -f "coverage_badge.svg"; then
    mv coverage_badge.svg build/coverage/badge
fi

genhtml -o build/coverage/html build/coverage/lcov/lcov.info
