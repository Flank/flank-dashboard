import 'package:ci_integration/config/parser/ci_integration_config_parser.dart';
import 'package:test/test.dart';

void main() {
  group("CiIntegrationConfigParser", () {
    const configParser = CiIntegrationConfigParser();
    const sourceConfig = "source:\n"
        " jenkins:\n"
        "   url: url\n"
        "   username: user\n"
        "   apiKey: apiKey\n"
        "   job_name: name\n";

    const destinationConfig = "destination:\n"
        " firestore:\n"
        "   firebase_project_id: firestoreId\n"
        "   metrics_project_id: id\n";

    test(
      ".parse() throws an ArgumentError if ciConfigYaml is null",
      () {
        expect(() => configParser.parse(null), throwsArgumentError);
      },
    );

    test(
      ".parse() throws FormatException if source config is missing",
      () {
        expect(
          () => configParser.parse(destinationConfig),
          throwsFormatException,
        );
      },
    );

    test(
      ".parse() throws FormatException if destination config is missing",
      () {
        expect(() => configParser.parse(sourceConfig), throwsFormatException);
      },
    );

    test(
      ".parse() creates CiIntegrationConfig from ci config yaml string",
      () {
        final config = configParser.parse('$sourceConfig$destinationConfig');

        expect(config, isNotNull);
        expect(config.source, isNotNull);
        expect(config.destination, isNotNull);
      },
    );
  });
}
