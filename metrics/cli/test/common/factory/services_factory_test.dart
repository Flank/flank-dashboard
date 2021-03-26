// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/factory/services_factory.dart';
import 'package:cli/common/model/services.dart';
import 'package:test/test.dart';

void main() {
  group("ServicesFactory", () {
    final servicesFactory = ServicesFactory();

    test(
      ".create() creates a Services instance",
      () {
        final services = servicesFactory.create();

        expect(services, isA<Services>());
      },
    );
  });
}
