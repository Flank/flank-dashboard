import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics/features/dashboard/data/model/data_model.dart';
import 'package:metrics/features/dashboard/domain/entities/core/build.dart';
import 'package:metrics/features/dashboard/domain/entities/core/build_status.dart';
import 'package:metrics/features/dashboard/domain/entities/core/percent.dart';

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

  /// Creates the [BuildData] from the [json] and it's [id].
  factory BuildData.fromJson(Map<String, dynamic> json, String id) {
    final buildResultValue = json['buildStatus'] as String;
    final durationMilliseconds = json['duration'] as int;
    final buildStatus = BuildStatus.values.firstWhere(
      (element) => '$element' == buildResultValue,
      orElse: () => null,
    );

    return BuildData(
      id: id,
      startedAt: (json['startedAt'] as Timestamp).toDate(),
      buildStatus: buildStatus,
      duration: Duration(milliseconds: durationMilliseconds),
      workflowName: json['workflow'] as String,
      url: json['url'] as String,
      coverage: Percent(json['coverage'] as double),
    );
  }

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
