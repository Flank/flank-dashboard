import 'package:meta/meta.dart';

/// A class that represents a project model and
/// used to communicate between [ChangeNotifier]s.
class ProjectModel {
  /// The identifier of this project.
  final String id;

  /// The name of this project.
  final String name;

  /// Creates an instance using the given [id] and [name].
  ///
  /// Throws an ArgumentError if either the [id] or [name] is `null`.
  ProjectModel({
    @required this.id,
    @required this.name,
  }) {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(name, 'name');
  }
}
