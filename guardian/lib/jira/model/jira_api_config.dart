import 'package:args/args.dart';

class JiraApiConfig {
  final String userEmail;
  final String apiToken;
  final String basePath;

  JiraApiConfig({
    this.userEmail,
    this.apiToken,
    this.basePath,
  });

  List<String> get nullFields {
    final result = <String>[];

    toJson().forEach((key, value) {
      if (value == null) {
        result.add(key);
      }
    });

    return result;
  }

  factory JiraApiConfig.fromArgs(ArgResults argResults) {
    if (argResults == null) return null;

    return JiraApiConfig(
      userEmail: argResults['userEmail'],
      apiToken: argResults['apiToken'],
      basePath: argResults['basePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'apiToken': apiToken,
      'basePath': basePath,
    };
  }
}
