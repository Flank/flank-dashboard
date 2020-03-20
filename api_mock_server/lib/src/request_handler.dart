import 'dart:io';

import 'package:api_mock_server/api_mock_server.dart';

/// Handle [HttpRequest] callback definition
typedef RequestHandleDispatcher = Future<void> Function(HttpRequest);

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
  final RequestHandleDispatcher dispatcher;

  RequestHandler._({
    this.method,
    this.pathMatcher,
    this.dispatcher,
  });

  /// Creates an instance of handler for the 'GET' HTTP method.
  RequestHandler.get({
    PathMatcher pathMatcher,
    RequestHandleDispatcher dispatcher,
  }) : this._(
          method: 'GET',
          pathMatcher: pathMatcher,
          dispatcher: dispatcher,
        );

  /// Creates an instance of handler for the 'POST' HTTP method.
  RequestHandler.post({
    PathMatcher pathMatcher,
    RequestHandleDispatcher dispatcher,
  }) : this._(
          method: 'POST',
          pathMatcher: pathMatcher,
          dispatcher: dispatcher,
        );

  /// Creates an instance of handler for the 'PUT' HTTP method.
  RequestHandler.put({
    PathMatcher pathMatcher,
    RequestHandleDispatcher dispatcher,
  }) : this._(
          method: 'PUT',
          pathMatcher: pathMatcher,
          dispatcher: dispatcher,
        );

  /// Creates an instance of handler for the 'DELETE' HTTP method.
  RequestHandler.delete({
    PathMatcher pathMatcher,
    RequestHandleDispatcher dispatcher,
  }) : this._(
          method: 'DELETE',
          pathMatcher: pathMatcher,
          dispatcher: dispatcher,
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

  /// Processes the [request] by calling [dispatcher] callback if presented.
  Future<void> handle(HttpRequest request) {
    return dispatcher?.call(request);
  }
}
