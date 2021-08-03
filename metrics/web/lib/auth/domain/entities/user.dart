// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';

/// Represents the logged in user entity.
@immutable
class User {
  /// A unique identifier of the user.
  final String id;

  /// An email of the user.
  final String email;

  final bool isAnonymous;

  /// Creates a new instance of the [User] with the given [id] and [email].
  ///
  /// The [id] must not be `null`.
  User({
    @required this.id,
    this.email,
    this.isAnonymous,
  }) {
    ArgumentError.checkNotNull(id, 'id');
  }
}
