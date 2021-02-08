// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents the user identifier parameter.
class UserIdParam extends Equatable {
  /// A unique identifier of the user.
  final String id;

  @override
  List<Object> get props => [id];

  /// Creates a new instance of the [UserIdParam].
  ///
  /// The [id] must not be `null`.
  UserIdParam({@required this.id}) {
    ArgumentError.checkNotNull(id, 'id');
  }
}
