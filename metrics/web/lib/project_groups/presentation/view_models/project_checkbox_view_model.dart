import 'package:meta/meta.dart';

/// A class that represents the project to display within a selection list.
class ProjectCheckboxViewModel {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// Determines if the project was checked.
  final bool isChecked;

  /// Creates the [ProjectCheckboxViewModel]
  ///
  /// The [id], the [name] and the [isChecked] must not be null.
  ProjectCheckboxViewModel({
    @required this.id,
    @required this.name,
    @required this.isChecked,
  })  : assert(id != null),
        assert(name != null),
        assert(isChecked != null);
}
