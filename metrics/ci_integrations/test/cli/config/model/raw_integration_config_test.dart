import 'package:ci_integration/cli/config/model/raw_integration_config.dart';
import 'package:test/test.dart';

void main() {
  group("RawIntegrationConfig", () {
    test(
      "throws an ArgumentError if the given source is null",
      () {
        expect(
          () => RawIntegrationConfig(
            sourceConfigMap: null,
            destinationConfigMap: const {},
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given destination is null",
      () {
        expect(
          () => RawIntegrationConfig(
            sourceConfigMap: const {},
            destinationConfigMap: null,
          ),
          throwsArgumentError,
        );
      },
    );
  });
}
