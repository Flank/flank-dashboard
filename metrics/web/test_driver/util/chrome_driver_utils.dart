import 'package:http/http.dart' as http;

import '../common/config/driver_tests_config.dart';

/// A utility class that provides a method for fetching information
/// about the Chromedriver.
class ChromeDriverUtils {
  /// Returns the latest version of the Chromedriver.
  static Future<String> getLatestVersion() async {
    final response = await http
        .get('${DriverTestsConfig.chromedriverUrlBasePath}/LATEST_RELEASE');

    if (response.statusCode != 200) {
      throw Exception(
        'Fetching the latest Chromedriver version is failed. Details: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    return response.body;
  }
}
