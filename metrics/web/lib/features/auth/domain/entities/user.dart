import 'package:meta/meta.dart';

/// Represents the user entity.
@immutable
class User {
  final String uid;
  final String email;

  /// Creates the [User] with [uid] and [email].
  const User({
    @required this.uid,
    @required this.email,
  })  : assert(uid != null),
        assert(email != null);
}
