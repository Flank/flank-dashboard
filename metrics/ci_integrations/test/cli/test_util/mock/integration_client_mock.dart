// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:mockito/mockito.dart';

class SourceClientMock extends Mock implements SourceClient {}

class DestinationClientMock extends Mock implements DestinationClient {}
