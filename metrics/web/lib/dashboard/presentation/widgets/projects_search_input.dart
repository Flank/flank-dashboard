import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';

/// [TextField] with the ability to search across projects.
class ProjectSearchInput extends StatelessWidget {
  /// Callback for [TextField] value change.
  final ValueChanged<String> onChanged;

  /// Creates [TextField] to search projects.
  ///
  /// Initializes widget [key] and [onChanged] callback.
  const ProjectSearchInput({
    Key key,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: CommonStrings.searchForProject,
      ),
    );
  }
}
