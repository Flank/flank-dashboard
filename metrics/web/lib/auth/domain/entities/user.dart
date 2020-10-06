import 'package:meta/meta.dart';

/// Represents the logged in user entity.
@immutable
class User {
  /// A identifier of the user.
  final String id;

  /// An email of the user.
  final String email;

  /// Creates a [User] with the given [id] and [email].
  ///
  /// Throws an [ArgumentError] if [id] is null.
  User({
    @required this.id,
    this.email,
  }) {
    ArgumentError.checkNotNull(id, 'id');
  }
}
