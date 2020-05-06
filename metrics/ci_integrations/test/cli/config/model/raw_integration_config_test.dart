import 'package:ci_integration/cli/config/model/raw_integration_config.dart';
import 'package:test/test.dart';

void main() {
  group("RawIntegrationConfig", () {
    test(
      "can't be created when the source is null",
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
      "can't be created when the destination is null",
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
