import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/debug_menu/domain/entities/local_config.dart';

void main() {
  group("LocalConfig", () {
    test(
      "creates an instance with the given parameters",
      () {
        const isFpsMonitorEnabled = true;

        const localConfig = LocalConfig(
          isFpsMonitorEnabled: isFpsMonitorEnabled,
        );

        expect(localConfig.isFpsMonitorEnabled, equals(isFpsMonitorEnabled));
      },
    );
  });
}
