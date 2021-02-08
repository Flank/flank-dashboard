// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:api_mock_server/api_mock_server.dart';

/// Handle [HttpRequest] callback definition.
typedef RequestProcessor = Future<void> Function(HttpRequest);

/// A class for handling HTTP requests.
///
/// Used by [ApiMockServer] and its implementers to delegate request handling.
class RequestHandler {
  /// HTTP request method this handler is able to process.
  ///
  /// Can be one of valid HTTP methods.
  final String method;

  /// The [PathMatcher] for the requested path and query parameters
  /// ([HttpRequest.uri]) this handler is able to process.
  final PathMatcher pathMatcher;

  /// Callback that processes request.
  final RequestProcessor processor;

  RequestHandler._({
    this.method,
    this.pathMatcher,
    this.processor,
  });

  /// Creates an instance of handler for the 'GET' HTTP method.
  RequestHandler.get({
    PathMatcher pathMatcher,
    RequestProcessor dispatcher,
  }) : this._(
          method: 'GET',
          pathMatcher: pathMatcher,
          processor: dispatcher,
        );

  /// Creates an instance of handler for the 'POST' HTTP method.
  RequestHandler.post({
    PathMatcher pathMatcher,
    RequestProcessor dispatcher,
  }) : this._(
          method: 'POST',
          pathMatcher: pathMatcher,
          processor: dispatcher,
        );

  /// Creates an instance of handler for the 'PUT' HTTP method.
  RequestHandler.put({
    PathMatcher pathMatcher,
    RequestProcessor dispatcher,
  }) : this._(
          method: 'PUT',
          pathMatcher: pathMatcher,
          processor: dispatcher,
        );

  /// Creates an instance of handler for the 'DELETE' HTTP method.
  RequestHandler.delete({
    PathMatcher pathMatcher,
    RequestProcessor dispatcher,
  }) : this._(
          method: 'DELETE',
          pathMatcher: pathMatcher,
          processor: dispatcher,
        );

  /// Checks whether this handler can process [request].
  ///
  /// Returns `true` if the [HttpRequest.method] of [request] equals this
  /// handler [method] and [pathMatcher] either `null` or [PathMatcher.match]
  /// the [request]. Otherwise, returns `false`.
  bool match(HttpRequest request) {
    final requestPath = request.uri.path.toString();
    return request.method == method &&
        (pathMatcher == null || pathMatcher.match(requestPath));
  }

  /// Processes the [request] by calling [processor] callback if presented.
  Future<void> handle(HttpRequest request) {
    return processor?.call(request);
  }
}
