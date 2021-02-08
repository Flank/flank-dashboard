// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A view model that represents data of the current renderer.
class RendererDisplayViewModel extends Equatable {
  /// A name of the current renderer.
  final String currentRenderer;

  @override
  List<Object> get props => [currentRenderer];

  /// Creates an instance of the [RendererDisplayViewModel] with the given
  /// [currentRenderer].
  ///
  /// Throws an [AssertionError] if the given [currentRenderer] is null.
  const RendererDisplayViewModel({
    @required this.currentRenderer,
  }) : assert(currentRenderer != null);
}
