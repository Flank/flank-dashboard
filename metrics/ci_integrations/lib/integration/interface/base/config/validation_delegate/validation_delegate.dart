// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';

/// An abstract class that provides methods for [Config]'s specific
/// fields validation.
abstract class ValidationDelegate {
  /// Validates the given [auth].
  Future<InteractionResult> validateAuth(AuthorizationBase auth);
}
