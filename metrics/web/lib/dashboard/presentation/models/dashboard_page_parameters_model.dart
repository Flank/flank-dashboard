// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/navigation/models/page_parameters_model.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';

/// A class, that represents [DashboardPage] parameters parsed from
/// query parameters.
class DashboardPageParametersModel implements PageParametersModel {
  /// A [String], that represents a name of the project.
  final String projectName;

  /// A [String], that represents an identifier of the project group.
  final String projectGroupId;

  /// Creates a [DashboardPageParametersModel] with the given parameters.
  const DashboardPageParametersModel({
    this.projectName,
    this.projectGroupId,
  });

  /// Creates a copy of this [DashboardPageParametersModel] but with
  /// the given fields replaced with the new values.
  DashboardPageParametersModel copyWith({
    String projectName,
    String projectGroupId,
  }) {
    return DashboardPageParametersModel(
      projectName: projectName ?? this.projectName,
      projectGroupId: projectGroupId ?? this.projectGroupId,
    );
  }

  /// Creates the [DashboardPageParametersModel] from the given [map].
  ///
  /// Returns `null` if the given [map] is `null`.
  factory DashboardPageParametersModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DashboardPageParametersModel(
      projectName: map['projectName'] as String,
      projectGroupId: map['projectGroupId'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'projectName': projectName,
      'projectGroupId': projectGroupId,
    };
  }
}
