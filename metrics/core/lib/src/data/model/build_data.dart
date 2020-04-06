import 'package:metrics_core/src/data/model/data_model.dart';
import 'package:metrics_core/src/domain/entities/build.dart';
import 'package:metrics_core/src/domain/entities/build_status.dart';
import 'package:metrics_core/src/domain/entities/percent.dart';

/// [DataModel] that represents the [Build] entity.
class BuildData extends Build implements DataModel {
  const BuildData({
    String id,
    String projectId,
    int buildNumber,
    DateTime startedAt,
    BuildStatus buildStatus,
    Duration duration,
    String workflowName,
    String url,
    Percent coverage,
  }) : super(
          id: id,
          projectId: projectId,
          buildNumber: buildNumber,
          startedAt: startedAt,
          buildStatus: buildStatus,
          duration: duration,
          workflowName: workflowName,
          url: url,
          coverage: coverage,
        );

  /// The unique identifier of this build.
  String get documentId => '${projectId}_$id';

  /// Creates the new instance of the [BuildData] based on current instance.
  ///
  /// If any of the passed parameters are null, or parameter isn't specified,
  /// the value will be copied from the current instance.
  BuildData copyWith({
    String id,
    String projectId,
    int buildNumber,
    DateTime startedAt,
    BuildStatus buildStatus,
    Duration duration,
    String workflowName,
    String url,
    Percent coverage,
  }) {
    return BuildData(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      buildNumber: buildNumber ?? this.buildNumber,
      startedAt: startedAt ?? this.startedAt,
      buildStatus: buildStatus ?? this.buildStatus,
      duration: duration ?? this.duration,
      workflowName: workflowName ?? this.workflowName,
      url: url ?? this.url,
      coverage: coverage ?? this.coverage,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'buildNumber': buildNumber,
      'startedAt': startedAt,
      'buildStatus': buildStatus?.toString(),
      'duration': duration?.inMilliseconds,
      'workflowName': workflowName,
      'url': url,
      'coverage': coverage?.value,
    };
  }
}
