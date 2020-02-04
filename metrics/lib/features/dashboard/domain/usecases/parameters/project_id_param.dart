import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Wrapper class for [projectId] parameter
class ProjectIdParam extends Equatable {
  final String projectId;

  const ProjectIdParam({@required this.projectId});

  @override
  List<Object> get props => [projectId];
}
