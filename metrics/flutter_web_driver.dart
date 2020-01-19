import 'dart:io';

import 'package:http/http.dart' as http;

extension FileNotExists on File {
  Future<bool> notExists() {
    return exists().then((onValue) {
      return !onValue;
    });
  }

  Future<void> assertExists() async {
    if (await notExists()) {
      print("async/await error: $this doesn't exist!");
    }
  }
}

extension StringNotExists on String {
  Future<bool> notExists() async {
    return File(this).notExists();
  }

  Future<void> assertExists() async {
    await File(this).assertExists();
  }
}

Future<void> download(String url, String fileName) async {
  final file = File(fileName);

  if (await file.notExists()) {
    print("Downloading $file");
    // Dart has no http.getSync
    await http.get(url).then((response) async {
      await file.writeAsBytes(response.bodyBytes);
    });
  }

  await file.assertExists();
}

Future<void> downloadSelenium() async {
  const url =
      "https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar";
  await download(url, "selenium.jar");
}

// Chrome driver version must match local chrome version
Future<void> downloadChromeDriver() async {
  const url =
      "https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_mac64.zip";
  const chromedriver = "chromedriver";
  const zipName = "$chromedriver.zip";
  await download(url, zipName);

  // TODO: rewrite to use https://pub.dev/packages/archive
  // Assumes 'unzip' bin is present
  if (await chromedriver.notExists()) {
    print("Unzipping $zipName");
    await Process.run('unzip', [zipName]);
    await chromedriver.assertExists();
  }
}

Future<void> main() async {
  await downloadSelenium();
  await downloadChromeDriver();

  // TODO: Start selenium server
  // java -jar "$SELENIUM"
  // TODO: Wait for selenium server ready:
  // https://github.com/SeleniumHQ/docker-selenium/blob/0f1d31e78436a759050d49d351eaf875c5658f21/README.md#using-a-bash-script-to-wait-for-the-grid

  // TODO: Start flutter app
  // flutter run -v -d chrome --target=lib/app.dart --web-port $PORT &
  // TODO: Wait for flutter app ready
  // implement health check endpoint??

  // TODO: Run flutter test
  // flutter drive --target=test_driver/app.dart -v --use-existing-app="http://localhost:$PORT/#/"

  // TODO: terminate Selenium process
  // kill $SELENIUM_PID
  // TODO: terminate Flutter app process
  // kill $FLUTTER_APP_PID

  // https://github.com/flutter/flutter/pull/45951/files#diff-50368ce5ddb0b3cdee53c3a71738a7f6R25
}
