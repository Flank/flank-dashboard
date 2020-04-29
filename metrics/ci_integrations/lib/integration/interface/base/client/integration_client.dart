import 'dart:async';

import 'package:http/http.dart';

/// An abstract class representing an integration client.
abstract class IntegrationClient {
  /// Closes this client and cleans up any resources associated with it.
  /// Similar to [Client.close].
  FutureOr<void> dispose();
}
