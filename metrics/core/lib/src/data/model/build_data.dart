import 'package:metrics_core/src/data/model/data_model.dart';
import 'package:metrics_core/src/domain/entities/build.dart';
import 'package:metrics_core/src/domain/entities/build_status.dart';
import 'package:metrics_core/src/domain/entities/percent.dart';

/// [DataModel] that represents the [Build] entity.
class BuildData extends Build implements DataModel {
  const BuildData({
    String id,
    int buildNumber,
    DateTime startedAt,
    BuildStatus buildStatus,
    Duration duration,
    String workflowName,
    String url,
    Percent coverage,
  }) : super(
          id: id,
          buildNumber: buildNumber,
          startedAt: startedAt,
          buildStatus: buildStatus,
          duration: duration,
          workflowName: workflowName,
          url: url,
          coverage: coverage,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'buildNumber': buildNumber,
      'startedAt': startedAt,
      'buildStatus': buildStatus.index,
      'duration': duration.inMilliseconds,
      'workflowName': workflowName,
      'url': url,
      'coverage': coverage.value,
    };
  }
}
