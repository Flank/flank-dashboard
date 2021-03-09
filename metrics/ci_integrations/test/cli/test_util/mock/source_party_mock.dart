// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/integration/interface/source/config/model/source_config.dart';
import 'package:ci_integration/integration/interface/source/party/source_party.dart';
import 'package:mockito/mockito.dart';

class SourcePartyMock<T extends SourceConfig, K extends SourceClient>
    extends Mock implements SourceParty<T, K> {}
