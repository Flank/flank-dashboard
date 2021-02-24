// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';

/// A stub implementation of the [ValidationDelegate].
class ValidationDelegateStub implements ValidationDelegate {
  @override
  Future<InteractionResult> validateAuth(AuthorizationBase auth) {
    return Future.value();
  }
}
