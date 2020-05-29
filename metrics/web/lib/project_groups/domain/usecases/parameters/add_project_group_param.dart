import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// Represents a param for adding a project group.
@immutable
class AddProjectGroupParam extends Equatable {
  final String projectGroupName;
  final List<String> projectIds;

  /// Creates the [AddProjectGroupParam] with the given [projectGroupName]
  /// and [projectIds].
  const AddProjectGroupParam(
    this.projectGroupName,
    this.projectIds,
  );

  @override
  List<Object> get props => [projectGroupName, projectIds];
}
