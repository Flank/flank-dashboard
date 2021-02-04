// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';

/// A class that represents the data of the project group to display
/// within a delete dialog.
@immutable
class DeleteProjectGroupDialogViewModel {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// Creates the [DeleteProjectGroupDialogViewModel].
  const DeleteProjectGroupDialogViewModel({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);
}
