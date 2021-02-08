// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/util/model/interaction_result.dart';

/// An abstract class that provides methods for [DestinationConfig]'s specific
/// fields validation.
abstract class DestinationValidationDelegate extends ValidationDelegate {
  /// Validates the given [destinationProjectId].
  Future<InteractionResult> validateDestinationProjectId(
    String destinationProjectId,
  );
}
