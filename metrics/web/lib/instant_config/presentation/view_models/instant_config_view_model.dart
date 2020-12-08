import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A view model that represents an instant config for a single feature.
abstract class InstantConfigViewModel extends Equatable {
  /// Indicates whether this feature is enabled.
  final bool isEnabled;

  @override
  List<Object> get props => [isEnabled];

  /// Creates a new instance of the [InstantConfigViewModel]
  /// with the given [isEnabled].
  const InstantConfigViewModel({
    @required this.isEnabled,
  }) : assert(isEnabled != null);
}
