// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/services.dart';
import 'package:test/test.dart';

import '../../test_utils/flutter_service_mock.dart';
import '../../test_utils/gcloud_service_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("Services", () {
    final flutterService = FlutterServiceMock();
    final gcloudService = GCloudServiceMock();

    test(
      "throws an ArgumentError if the given flutter service is null",
      () {
        expect(
          () => Services(flutterService: null, gcloudService: gcloudService),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given gcloud service is null",
      () {
        expect(
          () => Services(
            flutterService: flutterService,
            gcloudService: null,
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
        );

        expect(services.flutterService, equals(flutterService));
        expect(services.gcloudService, equals(gcloudService));
      },
    );
  });
}
