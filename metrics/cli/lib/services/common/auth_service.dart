// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/common/info_service.dart';

/// A base class for services that support authorization. Provides common
/// methods for handling the authorization.
abstract class AuthService extends InfoService {
  /// Initializes the given [authorization] for this service.
  void initializeAuthorization(String authorization);

  /// Resets the current authorization for this service.
  void resetAuthorization();
}
