import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';

/// The widget that represents a custom [TextField] for a search input.
class SearchInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  /// Creates the [SearchInputField].
  ///
  /// [onChanged] is a callback that report that an underlying value has changed.
  const SearchInputField({
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
