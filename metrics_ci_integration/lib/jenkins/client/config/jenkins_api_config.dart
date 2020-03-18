class JenkinsApiConfig {
  /// A Jenkins JSON API path.
  static const String jsonApiPath = '/api/json';

  /// The part of the `tree` query parameter that stands for
  /// [JenkinsBuildArtifact]'s properties to fetch.
  static const String artifactsTreeQuery = 'fileName,relativePath';

  /// The part of the `tree` query parameter that stands for [JenkinsBuild]'s
  /// properties to fetch.
  static const String buildTreeQuery =
      'number,duration,timestamp,result,url,artifacts[$artifactsTreeQuery]';

  /// The part of the `tree` query parameter that stands for [JenkinsJob]'s
  /// properties to fetch.
  static const String jobBaseTreeQuery = 'name,fullName,url';

  /// The part of the `tree` query parameter that extends common [JenkinsJob]'s
  /// properties to fetch with `jobs` and `builds` to be able detect a job type.
  static const String jobTreeQuery = '$jobBaseTreeQuery,jobs{,0},builds{,0}';
}
