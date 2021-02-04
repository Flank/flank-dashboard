// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

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

  /// Exact requested path this handler is able to process.
  ///
  /// Used instead of [pathPattern] if provided.
  final String path;

  /// Regular expression for the requested path and query parameters
  /// ([HttpRequest.uri]) this handler is able to process.
  final RegExp pathPattern;

  /// Callback that processes request.
  final RequestHandleDispatcher dispatcher;

  RequestHandler._({
    this.path,
    this.method,
    this.pathPattern,
    this.dispatcher,
  });

  /// Creates an instance of handler for the 'GET' HTTP method.
  RequestHandler.get({
    String path,
    RegExp pathPattern,
    RequestHandleDispatcher dispatcher,
  }) : this._(
          method: 'GET',
          path: path,
          pathPattern: pathPattern,
          dispatcher: dispatcher,
        );

  /// Creates an instance of handler for the 'POST' HTTP method.
  RequestHandler.post({
    String path,
    RegExp pathPattern,
    RequestHandleDispatcher dispatcher,
  }) : this._(
          method: 'POST',
          path: path,
          pathPattern: pathPattern,
          dispatcher: dispatcher,
        );

  /// Creates an instance of handler for the 'PUT' HTTP method.
  RequestHandler.put({
    String path,
    RegExp pathPattern,
    RequestHandleDispatcher dispatcher,
  }) : this._(
          method: 'PUT',
          path: path,
          pathPattern: pathPattern,
          dispatcher: dispatcher,
        );

  /// Creates an instance of handler for the 'DELETE' HTTP method.
  RequestHandler.delete({
    String path,
    RegExp pathPattern,
    RequestHandleDispatcher dispatcher,
  }) : this._(
          method: 'DELETE',
          path: path,
          pathPattern: pathPattern,
          dispatcher: dispatcher,
        );

  /// Checks whether this handler can process [request].
  ///
  /// If [path] is provided checks whether requested path equals to it.
  /// Otherwise, uses [pathPattern] regexp on requested path and returns `true`
  /// in case of full match.
  bool match(HttpRequest request) {
    final path = request.uri.toString();
    return request.method == method && pathPattern.stringMatch(path) == path;
  }

  /// Processes the [request] by calling [dispatcher] callback if presented.
  Future<void> handle(HttpRequest request) {
    return dispatcher?.call(request);
  }
}
