// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/builder/jenkins_url_builder.dart';
import 'package:ci_integration/client/jenkins/constants/tree_query.dart';
import 'package:ci_integration/client/jenkins/mapper/jenkins_build_result_mapper.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build_artifact.dart';

/// A class providing deserialization methods for the [JenkinsBuild] model.
class JenkinsBuildDeserializer {
  /// Creates a list of [JenkinsBuild]s from the given [list]
  /// of decoded JSON objects.
  ///
  /// Returns `null` if the given list is `null`.
  static List<JenkinsBuild> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) => fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Creates an instance of [JenkinsBuild] from the given decoded [json] object.
  ///
  /// Returns `null`, if the given [json] is `null`.
  static JenkinsBuild fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final timestamp = json['timestamp'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int);
    final duration = json['duration'] == null
        ? null
        : Duration(milliseconds: json['duration'] as int);

    const resultMapper = JenkinsBuildResultMapper();
    final result = resultMapper.map(json['result'] as String);

    final url = json['url'] as String;

    return JenkinsBuild(
      number: json['number'] as int,
      duration: duration,
      timestamp: timestamp,
      result: result,
      apiUrl: _buildApiUrl(url),
      url: url,
      building: json['building'] as bool,
      artifacts: JenkinsBuildArtifact.listFromJson(
        json['artifacts'] as List<dynamic>,
      ),
    );
  }

  /// Gets a [JenkinsBuild.apiUrl] for the given [webUrl] of the build.
  ///
  /// If the given [webUrl] is `null` or an empty string, returns `null`.
  static String _buildApiUrl(String webUrl) {
    if (webUrl == null || webUrl.isEmpty) return null;

    const urlBuilder = JenkinsUrlBuilder();
    return urlBuilder.build(
      webUrl,
      treeQuery: TreeQuery.build,
    );
  }
}
