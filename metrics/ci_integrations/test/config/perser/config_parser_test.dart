import 'dart:io';

import 'package:ci_integration/config/parser/config_parser.dart';
import 'package:test/test.dart';

void main() {
  group("ConfigParser", () {
    const sourceConfig = "source:\n"
        " jenkins:\n"
        "   url: url\n"
        "   username: user\n"
        "   password: pass\n"
        "   job_name: name\n";

    const destinationConfig = "destination:\n"
        " firestore:\n"
        "   firestore_project_id: firestoreId\n"
        "   metrics_project_id: id\n";

    File validConfigFile;
    File sourceConfigFile;
    File destinationConfigFile;

    setUpAll(() {
      final tempDir = Directory.systemTemp;

      validConfigFile = File('${tempDir.path}/test_config.yaml');
      sourceConfigFile = File('${tempDir.path}/source_config.yaml');
      destinationConfigFile = File('${tempDir.path}/destination_config.yaml');

      validConfigFile.createSync();
      sourceConfigFile.createSync();
      destinationConfigFile.createSync();

      validConfigFile.writeAsStringSync('$sourceConfig$destinationConfig');
      sourceConfigFile.writeAsStringSync(sourceConfig);
      destinationConfigFile.writeAsStringSync(destinationConfig);
    });

    tearDownAll(() {
      validConfigFile.deleteSync();
      sourceConfigFile.deleteSync();
      destinationConfigFile.deleteSync();
    });

    test(
      "can't be created with null configFilePath",
      () {
        expect(() => ConfigParser(configFilePath: null), throwsArgumentError);
      },
    );

    test(
      "throws the FileSystemException if config file not exists",
      () {
        final configParser = ConfigParser(
          configFilePath: "not_available_config.yaml",
        );

        expect(configParser.parse, throwsA(isA<FileSystemException>()));
      },
    );

    test(
      "can't creste config from file without source entity",
      () {
        final configParser = ConfigParser(
          configFilePath: destinationConfigFile.path,
        );

        expect(configParser.parse, throwsFormatException);
      },
    );

    test(
      "can't creste config from file without destination entity",
      () {
        final configParser = ConfigParser(
          configFilePath: sourceConfigFile.path,
        );

        expect(configParser.parse, throwsFormatException);
      },
    );

    test(
      "creates CiIntegrationConfig from config.yaml file",
      () {
        print(validConfigFile.path);
        final configParser = ConfigParser(configFilePath: validConfigFile.path);

        final config = configParser.parse();

        print(config);

        expect(config, isNotNull);
        expect(config.source, isNotNull);
        expect(config.destination, isNotNull);
      },
    );
  });
}
