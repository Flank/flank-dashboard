import 'package:http/http.dart' as http;

import '../common/config/driver_tests_config.dart';

/// A utility class that helps getting information about the Chromedriver.
class ChromeDriverUtils {
  /// Returns the identifier of the Chromedriver's latest version.
  static Future<String> getLatestVersion() async {
    final response = await http
        .get('${DriverTestsConfig.chromedriverUrlBasePath}/LATEST_RELEASE');

    return response.body;
  }
}
