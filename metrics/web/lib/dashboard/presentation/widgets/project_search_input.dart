import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';

/// THe [TextField] with the ability to search across projects.
class ProjectSearchInput extends StatelessWidget {
  final ValueChanged<String> onChanged;

  /// Creates the [ProjectSearchInput].
  ///
  /// After a certain [duration] triggers the given [onFilter] function.
  /// The [onFilter] should not be null.
  const ProjectSearchInput({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: CommonStrings.searchForProject,
      ),
    );
  }
}
