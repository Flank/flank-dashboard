import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/domain/entities/instant_config.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("InstantConfig", () {
    test(
      "creates an instance with the given parameters",
      () {
        const isLoginFormEnabled = true;
        const isFpsMonitorEnabled = false;
        const isRendererDisplayEnabled = false;

        final config = InstantConfig(
          isLoginFormEnabled: isLoginFormEnabled,
          isFpsMonitorEnabled: isFpsMonitorEnabled,
          isRendererDisplayEnabled: isRendererDisplayEnabled,
        );

        expect(config.isLoginFormEnabled, equals(isLoginFormEnabled));
        expect(config.isFpsMonitorEnabled, equals(isFpsMonitorEnabled));
        expect(
          config.isRendererDisplayEnabled,
          equals(isRendererDisplayEnabled),
        );
      },
    );
  });
}
