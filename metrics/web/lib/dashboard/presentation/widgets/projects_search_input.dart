// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';

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
    return MetricsTextFormField(
      onChanged: onChanged,
      prefixIconBuilder: (context, color) {
        return SvgImage(
          'icons/search.svg',
          width: 20.0,
          height: 20.0,
          color: color,
        );
      },
      hint: CommonStrings.searchForProject,
    );
  }
}
