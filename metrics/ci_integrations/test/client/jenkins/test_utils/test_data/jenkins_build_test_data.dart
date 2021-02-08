// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/constants/jenkins_constants.dart';
import 'package:ci_integration/client/jenkins/constants/tree_query.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';

/// A class providing a test data for [JenkinsBuild].
class JenkinsBuildTestData {
  /// Creates a [JenkinsBuild.apiUrl] for tests using the given
  /// [base] and [buildNumber].
  static String getApiUrl(String base, int buildNumber) {
    final path = '$buildNumber${JenkinsConstants.jsonApiPath}';
    final query = 'tree=${Uri.encodeQueryComponent(TreeQuery.build)}';

    return '$base/$path?$query';
  }
}
