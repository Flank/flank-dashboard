import 'package:ci_integration/ci_integration/config/model/raw_integration_config.dart';
import 'package:test/test.dart';

void main() {
  group("CiIntegrationConfig", () {
    test(
      "can't be created when the source is null",
      () {
        expect(
          () => RawIntegrationConfig(
            sourceConfigMap: null,
            destinationConfigMap: {},
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
            sourceConfigMap: {},
            destinationConfigMap: null,
          ),
          throwsArgumentError,
        );
      },
    );
  });
}
