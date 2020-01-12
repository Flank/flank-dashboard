#!/bin/bash

set -euxo pipefail

# Flutter Web Driver
# https://github.com/flutter/flutter/pull/45951

SELENIUM="selenium.jar"
SELENIUM_URL="https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar"

if ! [ -f "$SELENIUM" ]; then
  curl -o "$SELENIUM" "$SELENIUM_URL"
fi

java -jar "$SELENIUM"


# https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_mac64.zip
# https://github.com/flutter/flutter/pull/45951/files#diff-50368ce5ddb0b3cdee53c3a71738a7f6R25
