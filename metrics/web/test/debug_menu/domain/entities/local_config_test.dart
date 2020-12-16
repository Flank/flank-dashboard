import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/debug_menu/domain/entities/local_config.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("LocalConfig", () {
    test(
      "creates an instance with the given is fps monitor enabled",
      () {
        const isFpsMonitorEnabled = true;

        final localConfig =
            LocalConfig(isFpsMonitorEnabled: isFpsMonitorEnabled);

        expect(localConfig.isFpsMonitorEnabled, equals(isFpsMonitorEnabled));
      },
    );
  });
}
