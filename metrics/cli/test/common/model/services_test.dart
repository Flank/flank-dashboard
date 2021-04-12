// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/services.dart';
import 'package:test/test.dart';

import '../../test_utils/flutter_service_mock.dart';
import '../../test_utils/gcloud_service_mock.dart';
import '../../test_utils/npm_service_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("Services", () {
    final flutterService = FlutterServiceMock();
    final gcloudService = GCloudServiceMock();
    final npmService = NpmServiceMock();

    test(
      "throws an ArgumentError if the given Flutter service is null",
      () {
        expect(
          () => Services(
            flutterService: null,
            gcloudService: gcloudService,
            npmService: npmService,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given GCloud service is null",
      () {
        expect(
          () => Services(
            flutterService: flutterService,
            gcloudService: null,
            npmService: npmService,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given Npm service is null",
      () {
        expect(
          () => Services(
            flutterService: flutterService,
            gcloudService: gcloudService,
            npmService: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final services = Services(
          flutterService: flutterService,
          gcloudService: gcloudService,
          npmService: npmService,
        );

        expect(services.flutterService, equals(flutterService));
        expect(services.gcloudService, equals(gcloudService));
        expect(services.npmService, equals(npmService));
      },
    );
  });
}
