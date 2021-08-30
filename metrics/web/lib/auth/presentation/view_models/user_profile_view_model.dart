// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A view model that represents the logged in user profile.
class UserProfileViewModel extends Equatable {
  /// Indicates whether the logged in user is anonymous.
  final bool isAnonymous;

  /// Creates the [UserProfileViewModel] with the given [isAnonymous] value.
  const UserProfileViewModel({@required this.isAnonymous})
      : assert(isAnonymous != null);

  @override
  List<Object> get props => [isAnonymous];
}
