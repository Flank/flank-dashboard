import 'package:meta/meta.dart';

/// Represents the project entity.
@immutable
class Project {
  final String id;
  final String name;

  /// Creates the [Project] with [name] and [id].
  const Project({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);
}
