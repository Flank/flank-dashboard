// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/loading_placeholder.dart';

/// Displays the [loadingPlaceholder] widget if the data [isLoading].
class LoadingBuilder extends StatelessWidget {
  /// Defines if the data is loading or not.
  final bool isLoading;

  /// A [WidgetBuilder] used to build a child when the [isLoading] is false.
  final WidgetBuilder builder;

  /// A widget that will be shown when the data [isLoading].
  final Widget loadingPlaceholder;

  /// Creates the [LoadingBuilder].
  ///
  /// If the [loadingPlaceholder] is not specified, the [LoadingPlaceholder] used.
  ///
  /// [isLoading] and [builder] should not be null.
  const LoadingBuilder({
    Key key,
    @required this.isLoading,
    @required this.builder,
    this.loadingPlaceholder = const LoadingPlaceholder(),
  })  : assert(builder != null),
        assert(isLoading != null),
        assert(loadingPlaceholder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) return loadingPlaceholder;

    return builder(context);
  }
}
