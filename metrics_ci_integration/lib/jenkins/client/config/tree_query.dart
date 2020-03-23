/// A class that contains a `tree` query parameter's parts each standing for
/// the properties of data to fetch.
class TreeQuery {
  /// The part of the `tree` query parameter that stands for
  /// [JenkinsBuildArtifact]'s properties to fetch.
  static const String artifacts = 'fileName,relativePath';

  /// The part of the `tree` query parameter that stands for [JenkinsBuild]'s
  /// basic properties to fetch (does not include the `artifacts` property).
  static const String buildBase = 'number,duration,timestamp,result,url';

  /// The part of the `tree` query parameter that stands for [JenkinsBuild]'s
  /// properties to fetch.
  static const String build = '$buildBase,artifacts[$artifacts]';

  /// The part of the `tree` query parameter that stands for [JenkinsJob]'s
  /// properties to fetch.
  static const String jobBase = 'name,fullName,url';

  /// The part of the `tree` query parameter that extends common [JenkinsJob]'s
  /// properties to fetch with `jobs` and `builds` to be able detect a job type.
  static const String job = '$jobBase,jobs{,0},builds{,0}';
}
