import 'package:metrics_core/src/model/data_model.dart';
import 'package:metrics_core/src/entities/build.dart';
import 'package:metrics_core/src/entities/build_status.dart';
import 'package:metrics_core/src/entities/percent.dart';

/// [DataModel] that represents the [Build] entity.
class BuildData extends Build implements DataModel {
  const BuildData({
    String id,
    DateTime startedAt,
    BuildStatus buildStatus,
    Duration duration,
    String workflowName,
    String url,
    Percent coverage,
  }) : super(
          id: id,
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
      'startedAt': startedAt,
      'buildStatus': buildStatus.index,
      'duration': duration.inMilliseconds,
      'workflowName': workflowName,
      'url': url,
      'coverage': coverage.value,
    };
  }
}
