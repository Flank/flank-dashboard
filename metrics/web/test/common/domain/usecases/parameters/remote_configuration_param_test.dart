import 'package:metrics/common/domain/usecases/parameters/remote_configuration_param.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("RemoteConfigurationParam", () {
    const isFpsMonitorEnabled = true;
    const isLoginFormEnabled = false;
    const isRendererDisplayEnabled = false;

    test(
      "throws an AssertionError if the given is fps monitor enabled is null",
      () {
        expect(
          () => RemoteConfigurationParam(
            isFpsMonitorEnabled: null,
            isLoginFormEnabled: isLoginFormEnabled,
            isRendererDisplayEnabled: isRendererDisplayEnabled,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given is login form Enabled is null",
      () {
        expect(
          () => RemoteConfigurationParam(
            isFpsMonitorEnabled: isFpsMonitorEnabled,
            isLoginFormEnabled: null,
            isRendererDisplayEnabled: isRendererDisplayEnabled,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given is renderer display enabled is null",
      () {
        expect(
          () => RemoteConfigurationParam(
            isFpsMonitorEnabled: isFpsMonitorEnabled,
            isLoginFormEnabled: isLoginFormEnabled,
            isRendererDisplayEnabled: null,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given values",
      () {
        final param = RemoteConfigurationParam(
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
