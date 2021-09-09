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

  /// A flag that indicates whether the user is anonymous.
  final bool isAnonymous;

  /// Creates a new instance of the [User] with the given [id], [isAnonymous]
  /// and [email].
  ///
  /// The [id] and [isAnonymous] must not be `null`.
  User({
    @required this.id,
    @required this.isAnonymous,
    this.email,
  }) {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(isAnonymous, 'isAnonymous');
  }
}
