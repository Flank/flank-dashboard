import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/domain/entities/remote_configuration.dart';

// ignore_for_file: avoid_redundant_argument_values, prefer_const_constructors

void main() {
  group("RemoteConfiguration", () {
    const isLoginFormEnabled = true;
    const isFpsMonitorEnabled = false;
    const isRendererDisplayEnabled = false;

    test(
      "throws an ArgumentError if the given is login form enabled is null",
      () {
        expect(
          () => RemoteConfiguration(
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
          () => RemoteConfiguration(
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
          () => RemoteConfiguration(
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
        final configuration = RemoteConfiguration(
          isLoginFormEnabled: isLoginFormEnabled,
          isFpsMonitorEnabled: isFpsMonitorEnabled,
          isRendererDisplayEnabled: isRendererDisplayEnabled,
        );

        expect(configuration.isLoginFormEnabled, equals(isLoginFormEnabled));
        expect(configuration.isFpsMonitorEnabled, equals(isFpsMonitorEnabled));
        expect(configuration.isRendererDisplayEnabled,
            equals(isRendererDisplayEnabled));
      },
    );
  });
}
