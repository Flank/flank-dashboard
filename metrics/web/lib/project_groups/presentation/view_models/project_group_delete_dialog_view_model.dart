import 'package:meta/meta.dart';

/// A class that represents the data of the project group to display
/// inside a delete dialog.
class ProjectGroupDeleteDialogViewModel {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// Creates the [ProjectGroupDeleteDialogViewModel].
  ///
  /// The [id] and the [name] must not be null.
  ProjectGroupDeleteDialogViewModel({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);
}
