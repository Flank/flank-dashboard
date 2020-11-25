import 'package:http/http.dart' as http;

/// A utility class that helps getting information about the Chromedriver.
class ChromeDriverUtils {
  /// A URL needed to fetch the identifier of the Chromedriver's latest version.
  static const latestVersionUrl =
      'https://chromedriver.storage.googleapis.com/LATEST_RELEASE';

  /// Returns the identifier of the Chromedriver's latest version.
  static Future<String> getLatestVersion() async {
    final response = await http.get(latestVersionUrl);

    return response.body;
  }
}
