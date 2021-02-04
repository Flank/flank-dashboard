// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:http/http.dart' as http;

import '../cli/web_driver/chrome_driver.dart';

/// A utility class that provides a method for fetching information
/// about the Chromedriver.
class ChromeDriverUtils {
  /// Returns the latest version of the Chromedriver.
  static Future<String> getLatestVersion() async {
    final response = await http
        .get('${ChromeDriver.chromedriverUrlBasePath}/LATEST_RELEASE');

    if (response.statusCode != 200) {
      throw Exception(
        'Fetching the latest Chromedriver version is failed. Details: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    return response.body;
  }
}
