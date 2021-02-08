// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:test/test.dart';

void main() {
  group("RouteName", () {
    test(".values contains all available route names", () {
      const expectedValues = {
        RouteName.loading,
        RouteName.login,
        RouteName.dashboard,
        RouteName.projectGroups,
      };

      final values = RouteName.values;

      expect(values, containsAll(expectedValues));
    });
  });
}
