import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A view model that represents a current renderer.
class RendererDisplayViewModel extends Equatable {
  /// A current renderer's name.
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
