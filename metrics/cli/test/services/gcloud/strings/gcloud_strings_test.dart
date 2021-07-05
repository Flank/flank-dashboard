// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/gcloud/strings/gcloud_strings.dart';
import 'package:test/test.dart';

void main() {
  group("GCloudStrings", () {
    const projectId = 'projectId';
    const projectName = 'projectName';

    test(
      ".configureOAuth() returns a message that contains the given project id",
      () {
        expect(
          GCloudStrings.configureOAuth(projectId),
          contains(projectId),
        );
      },
    );

    test(
      ".configureProjectOrganization() returns a message that contains the given project id",
      () {
        expect(
          GCloudStrings.configureProjectOrganization(projectId),
          contains(projectId),
        );
      },
    );

    test(
      ".enterProjectName() returns a message that contains the given project id",
      () {
        expect(
          GCloudStrings.enterProjectName(projectId),
          contains(projectId),
        );
      },
    );

    test(
      ".confirmProjectName() returns a message that contains the given project name",
      () {
        expect(
          GCloudStrings.confirmProjectName(projectName),
          contains(projectName),
        );
      },
    );
  });
}
