import 'package:metrics_core/src/data/model/data_model.dart';
import 'package:metrics_core/src/domain/entities/build.dart';
import 'package:metrics_core/src/domain/entities/build_status.dart';
import 'package:metrics_core/src/domain/value_objects/percent.dart';

/// [DataModel] that represents the [Build] entity.
class BuildData extends Build implements DataModel {
  /// Creates a new instance of the [BuildData].
  const BuildData({
    String id,
    String projectId,
    int buildNumber,
    DateTime startedAt,
    BuildStatus buildStatus,
    Duration duration,
    String workflowName,
    String url,
    String apiUrl,
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
          apiUrl: apiUrl,
          coverage: coverage,
        );

  /// Creates a copy of this [BuildData] but with the given fields
  /// replaced with the new values.
  BuildData copyWith({
    String id,
    String projectId,
    int buildNumber,
    DateTime startedAt,
    BuildStatus buildStatus,
    Duration duration,
    String workflowName,
    String url,
    String apiUrl,
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
      apiUrl: apiUrl ?? this.apiUrl,
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
      'apiUrl': apiUrl,
      'coverage': coverage?.value,
    };
  }
}
