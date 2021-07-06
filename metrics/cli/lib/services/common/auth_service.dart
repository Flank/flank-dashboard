// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/common/info_service.dart';

/// A base class for services that support authorization, provides common
/// methods for setting the authorization up.
abstract class AuthService extends InfoService {
  /// Initializes the given [authorization] for this service.
  void initializeAuthorization(String authorization);

  /// Resets this service current authorization.
  void resetAuthorization();
}
