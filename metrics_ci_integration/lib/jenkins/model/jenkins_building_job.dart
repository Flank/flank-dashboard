import 'package:ci_integration/jenkins/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/model/jenkins_job.dart';
import 'package:meta/meta.dart';

/// A class representing a Jenkins building job.
class JenkinsBuildingJob extends JenkinsJob {
  /// The first build performed within this job.
  final JenkinsBuild firstBuild;

  /// The current last build performed within this job.
  final JenkinsBuild lastBuild;

  /// A list of builds performed within this job.
  final List<JenkinsBuild> builds;

  @override
  List<Object> get props =>
      super.props..addAll([firstBuild, lastBuild, builds]);

  const JenkinsBuildingJob({
    @required String name,
    String fullName,
    String url,
    this.firstBuild,
    this.lastBuild,
    this.builds,
  }) : super(name: name, fullName: fullName, url: url);

  /// Creates an instance of building job from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory JenkinsBuildingJob.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JenkinsBuildingJob(
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      url: json['url'] as String,
      firstBuild: JenkinsBuild.fromJson(
        json['firstBuild'] as Map<String, dynamic>,
      ),
      lastBuild: JenkinsBuild.fromJson(
        json['lastBuild'] as Map<String, dynamic>,
      ),
      builds: JenkinsBuild.listFromJson(json['builds'] as List<dynamic>),
    );
  }

  /// Converts object into the [Map].
  ///
  /// The resulting map will include only non-null fields of an object it
  /// represents and can be encoded to a JSON object.
  /// Populates [JenkinsJob.toJson] with building job specific fields.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();

    if (firstBuild != null) json['firstBuild'] = firstBuild.toJson();
    if (lastBuild != null) json['lastBuild'] = lastBuild.toJson();
    if (builds != null) json['builds'] = builds.map((b) => b.toJson()).toList();

    return json;
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}
