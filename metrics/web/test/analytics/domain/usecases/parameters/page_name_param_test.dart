// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/analytics/domain/entities/page_name.dart';
import 'package:metrics/analytics/domain/usecases/parameters/page_name_param.dart';
import 'package:test/test.dart';

void main() {
  const pageName = PageName.dashboardPage;
  group("PageNameParam", () {
    test("throws an ArgumentError if the given page name is null", () {
      expect(() => PageNameParam(pageName: null), throwsArgumentError);
    });

    test("creates an instance with the given params", () {
      final pageNameParam = PageNameParam(pageName: pageName);

      expect(pageNameParam.pageName, equals(pageName));
    });
  });
}
