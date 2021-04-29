// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/factory/services_factory.dart';
import 'package:cli/firebase/adapter/firebase_cli_service_adapter.dart';
import 'package:cli/flutter/adapter/flutter_cli_service_adapter.dart';
import 'package:cli/gcloud/adapter/gcloud_cli_service_adapter.dart';
import 'package:cli/git/adapter/git_cli_service_adapter.dart';
import 'package:cli/npm/adapter/npm_cli_service_adapter.dart';
import 'package:cli/sentry/adapter/sentry_cli_service_adapter.dart';
import 'package:test/test.dart';

void main() {
  group("ServicesFactory", () {
    const servicesFactory = ServicesFactory();

    test(
      ".create() creates a Services instance with the Flutter service adapter",
      () {
        final services = servicesFactory.create();

        expect(services.flutterService, isA<FlutterCliServiceAdapter>());
      },
    );

    test(
      ".create() creates a Services instance with the GCloud service adapter",
      () {
        final services = servicesFactory.create();

        expect(services.gcloudService, isA<GCloudCliServiceAdapter>());
      },
    );

    test(
      ".create() creates a Services instance with the Npm service adapter",
      () {
        final services = servicesFactory.create();

        expect(services.npmService, isA<NpmCliServiceAdapter>());
      },
    );

    test(
      ".create() creates a Services instance with the Git service adapter",
      () {
        final services = servicesFactory.create();

        expect(services.gitService, isA<GitCliServiceAdapter>());
      },
    );

    test(
      ".create() creates a Services instance with the Firebase service adapter",
      () {
        final services = servicesFactory.create();

        expect(services.firebaseService, isA<FirebaseCliServiceAdapter>());
      },
    );

    test(
      ".create() creates a Services instance with the Sentry service adapter",
      () {
        final services = servicesFactory.create();

        expect(services.sentryService, isA<SentryCliServiceAdapter>());
      },
    );
  });
}
