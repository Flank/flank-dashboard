import 'package:meta/meta.dart';

/// Represents the project entity.
@immutable
class Project {
  /// An identifier of the project.
  final String id;

  /// A name of this project.
  final String name;

  /// Creates a new instance of the [Project].
  const Project({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);
}
