import 'package:metrics/instant_config/data/model/instant_config_data.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("InstantConfigData", () {
    const isLoginFormEnabled = true;
    const isFpsMonitorEnabled = true;
    const isRendererDisplayEnabled = true;
    const isDebugMenuEnabled = true;

    const json = {
      'isLoginFormEnabled': isLoginFormEnabled,
      'isFpsMonitorEnabled': isFpsMonitorEnabled,
      'isRendererDisplayEnabled': isRendererDisplayEnabled,
      'isDebugMenuEnabled': isDebugMenuEnabled,
    };

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final config = InstantConfigData.fromJson(null);

        expect(config, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        final expectedConfig = InstantConfigData(
          isLoginFormEnabled: isLoginFormEnabled,
          isFpsMonitorEnabled: isFpsMonitorEnabled,
          isRendererDisplayEnabled: isRendererDisplayEnabled,
          isDebugMenuEnabled: isDebugMenuEnabled,
        );

        final config = InstantConfigData.fromJson(json);

        expect(config, equals(expectedConfig));
      },
    );

    test(
      ".toJson() converts an instance to the json encodable map",
      () {
        final config = InstantConfigData(
          isLoginFormEnabled: isLoginFormEnabled,
          isFpsMonitorEnabled: isFpsMonitorEnabled,
          isRendererDisplayEnabled: isRendererDisplayEnabled,
          isDebugMenuEnabled: isDebugMenuEnabled,
        );

        expect(config.toJson(), equals(json));
      },
    );
  });
}
