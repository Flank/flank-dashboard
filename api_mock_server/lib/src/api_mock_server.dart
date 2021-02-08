// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:api_mock_server/api_mock_server.dart';

/// An abstract class for the mock web server binding.
///
/// Implementers must provide a list of [RequestHandler]s overriding the
/// [handlers] getter.
abstract class ApiMockServer {
  HttpServer _server;
  StreamSubscription<HttpRequest> _requestSubscription;

  /// A list of available [RequestHandler]s for requests.
  List<RequestHandler> get handlers;

  /// A list of valid [AuthCredentials] for requests to be verified.
  ///
  /// The implementation defaults to returning `null` which means that no
  /// authorization for requests is required.
  List<AuthCredentials> get authCredentials => null;

  String get url => 'http://${_server.address.host}:${_server.port}';

  /// Starts listening for HTTP requests on the specified [host] and [port].
  ///
  /// If no [address] is provided the default [InternetAddress.loopbackIPv4],
  /// which is effectively localhost, will be used.
  /// A [port] defaults to `0` which means that an ephemeral port will be
  /// chosen by the system.
  Future<void> start({
    dynamic address,
    int port = 0,
  }) async {
    _server = await HttpServer.bind(
      address ?? InternetAddress.loopbackIPv4,
      port,
    );
    _requestSubscription = _server.listen(handleRequest, onError: print);
  }

  /// Verifies that [request] is authorized.
  ///
  /// Uses the [authCredentials] list of authorization data to verify a request.
  /// Returns `true` if [request] is valid. Implementers can specify auth for
  /// verification the mock server either overriding [authCredentials] or this
  /// method.
  bool verifyRequest(HttpRequest request) {
    final isValid = authCredentials?.any((credentials) {
      return request.headers.value(credentials.header) == credentials.token;
    });

    return isValid ?? true;
  }

  /// Handles each HTTP request received.
  ///
  /// Verifies authorization calling [verifyRequest] and if it is invalid,
  /// responses with [HttpStatus.unauthorized]. If authorization is valid, looks
  /// for a [RequestHandler] from [handlers] that match request and delegates
  /// handling. If no handler is found, responses with
  /// [HttpStatus.notImplemented].
  void handleRequest(HttpRequest request) {
    if (verifyRequest(request)) {
      final handler = handlers?.firstWhere(
        (handler) => handler.match(request),
        orElse: () => null,
      );

      if (handler == null) {
        request.response
          ..statusCode = HttpStatus.notImplemented
          ..close();
      } else {
        handler.handle(request);
      }
    } else {
      request.response
        ..statusCode = HttpStatus.unauthorized
        ..close();
    }
  }

  /// Stops server from listening for new requests.
  ///
  /// If [force] is `true`, active connections will be closed immediately.
  /// Defaults to `true`.
  Future<void> close({
    bool force = true,
  }) async {
    await _server.close(force: force);
    await _requestSubscription?.cancel();
    _server = null;
  }
}
