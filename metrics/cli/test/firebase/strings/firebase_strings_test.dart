// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/firebase/strings/firebase_strings.dart';
import 'package:test/test.dart';

void main() {
  group('FirebaseStrings', () {
    const projectId = 'projectId';

    test(
      ".configureAuthProviders() returns a message that contains the given project id",
      () {
        expect(
          FirebaseStrings.configureAuthProviders(projectId),
          contains(projectId),
        );
      },
    );

    test(
      ".enableAnalytics() returns a message that contains the given project id",
      () {
        expect(
          FirebaseStrings.enableAnalytics(projectId),
          contains(projectId),
        );
      },
    );

    test(
      ".initializeData() returns a message that contains the given project id",
      () {
        expect(
          FirebaseStrings.initializeData(projectId),
          contains(projectId),
        );
      },
    );

    test(
      ".upgradeBillingPlan() returns a message that contains the given project id",
      () {
        expect(
          FirebaseStrings.upgradeBillingPlan(projectId),
          contains(projectId),
        );
      },
    );
  });
}
