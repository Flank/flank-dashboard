// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/navigation/models/page_parameters_model.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';

/// A class that represents [DashboardPage] parameters parsed from
/// query parameters.
class DashboardPageParametersModel extends PageParametersModel {
  /// A [String] that represents a name of the project.
  final String projectFilter;

  /// A [String] that represents an identifier of the selected project group.
  final String projectGroupId;

  /// Creates a new instance of the [DashboardPageParametersModel]
  /// with the given parameters.
  const DashboardPageParametersModel({
    this.projectFilter,
    this.projectGroupId,
  });

  @override
  List<Object> get props => [projectFilter, projectGroupId];

  /// Creates a copy of this [DashboardPageParametersModel] but with
  /// the given fields replaced with the new values.
  DashboardPageParametersModel copyWith({
    String projectFilter,
    String projectGroupId,
  }) {
    return DashboardPageParametersModel(
      projectFilter: projectFilter ?? this.projectFilter,
      projectGroupId: projectGroupId ?? this.projectGroupId,
    );
  }

  /// Creates the [DashboardPageParametersModel] from the given [map].
  ///
  /// Returns `null` if the given [map] is `null`.
  factory DashboardPageParametersModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DashboardPageParametersModel(
      projectFilter: map['projectFilter'] as String,
      projectGroupId: map['projectGroupId'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'projectFilter': projectFilter,
      'projectGroupId': projectGroupId,
    };
  }
}
