// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/party/integration_party.dart';

/// An abstract class providing the list of integrations.
abstract class Parties<T extends IntegrationParty> {
  /// The list of [IntegrationParty] used to define integrations.
  ///
  /// This is preferably to be an unmodifiable list.
  List<T> get parties;
}
