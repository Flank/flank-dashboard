import 'package:meta/meta.dart';

/// Represents the project entity.
@immutable
class Project {
  /// An identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// Creates the [Project] with [name] and [id].
  const Project({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);
}
