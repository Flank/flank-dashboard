import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/domain/entities/instant_config.dart';

// ignore_for_file: avoid_redundant_argument_values, prefer_const_constructors

void main() {
  group("InstantConfig", () {
    const isLoginFormEnabled = true;
    const isFpsMonitorEnabled = false;
    const isRendererDisplayEnabled = false;

    test(
      "throws an ArgumentError if the given is login form enabled is null",
      () {
        expect(
          () => InstantConfig(
            isLoginFormEnabled: null,
            isFpsMonitorEnabled: isFpsMonitorEnabled,
            isRendererDisplayEnabled: isRendererDisplayEnabled,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given is fps monitor enabled is null",
      () {
        expect(
          () => InstantConfig(
            isLoginFormEnabled: isLoginFormEnabled,
            isFpsMonitorEnabled: null,
            isRendererDisplayEnabled: isRendererDisplayEnabled,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given is renderer display enabled is null",
      () {
        expect(
          () => InstantConfig(
            isLoginFormEnabled: isLoginFormEnabled,
            isFpsMonitorEnabled: isFpsMonitorEnabled,
            isRendererDisplayEnabled: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final config = InstantConfig(
          isLoginFormEnabled: isLoginFormEnabled,
          isFpsMonitorEnabled: isFpsMonitorEnabled,
          isRendererDisplayEnabled: isRendererDisplayEnabled,
        );

        expect(config.isLoginFormEnabled, equals(isLoginFormEnabled));
        expect(config.isFpsMonitorEnabled, equals(isFpsMonitorEnabled));
        expect(config.isRendererDisplayEnabled,
            equals(isRendererDisplayEnabled));
      },
    );
  });
}
