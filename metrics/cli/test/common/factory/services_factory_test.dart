// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/factory/services_factory.dart';
import 'package:cli/flutter/adapter/flutter_cli_service_adapter.dart';
import 'package:cli/gcloud/adapter/gcloud_cli_service_adapter.dart';
import 'package:test/test.dart';

void main() {
  group("ServicesFactory", () {
    const servicesFactory = ServicesFactory();

    test(
      ".create() creates a Services instance with the GCloud service adapter",
      () {
        final services = servicesFactory.create();

        expect(services.gcloudService, isA<GCloudCliServiceAdapter>());
      },
    );

    test(
      ".create() creates a Services instance with the Flutter service adapter",
      () {
        final services = servicesFactory.create();

        expect(services.flutterService, isA<FlutterCliServiceAdapter>());
      },
    );
  });
}
