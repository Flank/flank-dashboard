import 'package:meta/meta.dart';

/// Represents the project to display within selection list.
class ProjectSelectionViewModel {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project
  final String name;

  /// Determines if the project was checked.
  final bool isChecked;

  /// Creates the [ProjectSelectionViewModel]
  ///
  /// The [id], the [name] and the [isChecked] must not be null.
  ProjectSelectionViewModel({
    @required this.id,
    @required this.name,
    @required this.isChecked,
  })  : assert(id != null),
        assert(name != null),
        assert(isChecked != null);
}
