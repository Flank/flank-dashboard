import 'package:meta/meta.dart';

/// Represents the logged in user entity.
@immutable
class User {
  /// A unique identifier of the user.
  final String id;

  /// An email of the user.
  final String email;

  /// Creates a new instance of the [User] with the given [id] and [email].
  ///
  /// The [id] must not be `null`.
  User({
    @required this.id,
    this.email,
  }) {
    ArgumentError.checkNotNull(id, 'id');
  }
}
