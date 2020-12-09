import 'package:metrics/instant_config/domain/usecases/parameters/instant_config_param.dart';
import 'package:test/test.dart';

void main() {
  group("InstantConfigParam", () {
    const isFpsMonitorEnabled = true;
    const isLoginFormEnabled = false;
    const isRendererDisplayEnabled = false;

    test(
      "throws an ArgumentError if the given is fps monitor enabled is null",
      () {
        expect(
          () => InstantConfigParam(
            isFpsMonitorEnabled: null,
            isLoginFormEnabled: isLoginFormEnabled,
            isRendererDisplayEnabled: isRendererDisplayEnabled,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given is login form Enabled is null",
      () {
        expect(
          () => InstantConfigParam(
            isFpsMonitorEnabled: isFpsMonitorEnabled,
            isLoginFormEnabled: null,
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
          () => InstantConfigParam(
            isFpsMonitorEnabled: isFpsMonitorEnabled,
            isLoginFormEnabled: isLoginFormEnabled,
            isRendererDisplayEnabled: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given values",
      () {
        final param = InstantConfigParam(
          isFpsMonitorEnabled: isFpsMonitorEnabled,
          isLoginFormEnabled: isLoginFormEnabled,
          isRendererDisplayEnabled: isRendererDisplayEnabled,
        );

        expect(param.isFpsMonitorEnabled, equals(isFpsMonitorEnabled));
        expect(param.isLoginFormEnabled, equals(isLoginFormEnabled));
        expect(
          param.isRendererDisplayEnabled,
          equals(isRendererDisplayEnabled),
        );
      },
    );
  });
}
