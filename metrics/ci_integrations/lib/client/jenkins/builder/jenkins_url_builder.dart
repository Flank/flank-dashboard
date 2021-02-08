// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/constants/jenkins_constants.dart';
import 'package:ci_integration/client/jenkins/constants/tree_query.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_job.dart';
import 'package:ci_integration/util/url/url_utils.dart';

/// A class that builds URLs for Jenkins API requests.
class JenkinsUrlBuilder {
  /// Creates a new instance of the [JenkinsUrlBuilder].
  const JenkinsUrlBuilder();

  /// Builds a ready-to-use URL for Jenkins API requests using the given [url].
  /// Calls the [UrlUtils.buildUrl] method to finalize the resulting URL.
  ///
  /// A [url] can be either a link to the Jenkins instance or a link to an
  /// object from Jenkins (such as [JenkinsBuild.url], [JenkinsJob.url], etc.)
  /// A [path] is additional path segments for the given [url] base.
  /// A [treeQuery] is a value for the `tree` query parameter to filter a
  /// response body content (see [TreeQuery] constants).
  String build(
    String url, {
    String path,
    String treeQuery,
  }) {
    Map<String, String> queryMap;

    if (treeQuery != null && treeQuery.isNotEmpty) {
      queryMap = {'tree': treeQuery};
    }

    return UrlUtils.buildUrl(
      url,
      path: _addApiPath(path),
      queryParameters: queryMap,
    );
  }

  /// Adds the [JenkinsConstants.jsonApiPath] to the given [basePath] of the URL.
  String _addApiPath(String basePath) {
    const apiPath = JenkinsConstants.jsonApiPath;
    String result;

    if (basePath == null || basePath.isEmpty) {
      result = apiPath;
    } else if (basePath.endsWith(apiPath) || basePath.endsWith('$apiPath/')) {
      result = basePath;
    } else {
      final noTrailingSlashPath = UrlUtils.removeTrailingSlash(basePath);
      result = '$noTrailingSlashPath$apiPath';
    }

    return result;
  }
}
