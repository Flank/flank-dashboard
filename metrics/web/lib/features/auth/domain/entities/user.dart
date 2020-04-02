import 'package:meta/meta.dart';

/// Represents the logged in user entity.
class User {
  final String id;
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
