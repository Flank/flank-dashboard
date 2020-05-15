import 'package:equatable/equatable.dart';

/// A base class for all value objects.
abstract class ValueObject<T> extends Equatable {
  /// Provides a value of this object.
  T get value;

  @override
  List<Object> get props => [value];
}
