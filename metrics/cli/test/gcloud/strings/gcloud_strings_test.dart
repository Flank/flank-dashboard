// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/gcloud/strings/gcloud_strings.dart';
import 'package:test/test.dart';

void main() {
  group('GCloudStrings', () {
    test(
      ".configureOAuth() returns a message that contains the given project id",
      () {
        const projectId = 'projectId';

        expect(
          GCloudStrings.configureOAuth(projectId),
          contains(projectId),
        );
      },
    );
  });
}
