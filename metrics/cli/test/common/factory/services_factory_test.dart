// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/factory/services_factory.dart';
import 'package:cli/flutter/service/flutter_service.dart';
import 'package:cli/gcloud/service/gcloud_service.dart';
import 'package:test/test.dart';

void main() {
  group("ServicesFactory", () {
    final servicesFactory = ServicesFactory();

    test(
      ".create() creates a Services instance with the correct values",
      () {
        final services = servicesFactory.create();

        expect(services.gcloudService, isA<GCloudService>());
        expect(services.flutterService, isA<FlutterService>());
      },
    );
  });
}
