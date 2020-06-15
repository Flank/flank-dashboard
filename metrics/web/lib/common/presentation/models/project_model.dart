import 'package:meta/meta.dart';

/// A class that represents a project model and
/// used to communicate between change notifiers.
class ProjectModel {
  /// The project's identifier.
  final String id;

  /// The project's name.
  final String name;

  /// Creates an instance, using an [id] and a [name].
  ///
  /// Throws an ArgumentError if the [id] or the [name] is null.
  ProjectModel({
    @required this.id,
    @required this.name,
  }) {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(name, 'name');
  }
}
