#!/bin/bash

set -euxo pipefail

# Flutter Web Driver
# https://github.com/flutter/flutter/pull/45951

PORT=9499

# Selenium Server

SELENIUM="selenium.jar"
SELENIUM_URL="https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar"

if ! [ -f "$SELENIUM" ]; then
  curl -o "$SELENIUM" "$SELENIUM_URL"
fi

# Chrome Driver to run tests (Needs to match chrome version)

CHROMEDRIVER="chromedriver"
CHROMEDRIVER_URL="https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_mac64.zip"

if ! [ -f "$CHROMEDRIVER" ]; then
  curl -o "$CHROMEDRIVER.zip" "$CHROMEDRIVER_URL"
  unzip "$CHROMEDRIVER.zip"
fi

# Run Selenium server with Chrome Driver to run tests
java -jar "$SELENIUM" &
SELENIUM_PID=$!

# Start Flutter app
flutter run -v -d chrome --target=lib/app.dart --web-port $PORT &
FLUTTER_APP_PID=$!

# TODO wait till Flutter app is started more reliably & efficiently - See commented script below
sleep 30s

#FILE_TO_WATCH='flutter_app.log'
#SEARCH_PATTERN='Debug service listening on'
#tail -f -n0 ${FILE_TO_WATCH} | grep -qe ${SEARCH_PATTERN}
#
#if [ $? == 1 ]; then
#    echo "Search terminated without finding the pattern"
#fi

# Run separately to make sure that it works
# TODO: It looks as first time it never connects, need to run twice - figure you why first time it's not working
flutter drive --target=test_driver/app.dart -v --use-existing-app="http://localhost:$PORT/#/"

#Wait till tests runned manually and complete
#sleep 100000s

# Stop background processes
kill $SELENIUM_PID
kill $FLUTTER_APP_PID

# https://github.com/flutter/flutter/pull/45951/files#diff-50368ce5ddb0b3cdee53c3a71738a7f6R25
