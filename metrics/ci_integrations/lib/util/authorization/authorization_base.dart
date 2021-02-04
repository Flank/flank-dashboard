// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of authorization;

/// An abstract class for authorization method used within HTTP requests.
///
/// This class stands for the direct representation of the authorization method
/// used in an HTTP request. Since the implementation of auth flow depends on
/// application/program context, this class doesn't provide methods for storing,
/// fetching, revoking or other auth-related functionality for tokens. Instead,
/// it provides API for mapping authorization credentials to HTTP-valid header.
abstract class AuthorizationBase extends Equatable {
  /// The HTTP header used by the authorization method.
  ///
  /// Usually, equals to [HttpHeaders.authorizationHeader].
  final String _httpHeader;

  /// The token that should be used for the authorization.
  final String _token;

  @nonVirtual
  @override
  List<Object> get props => [_httpHeader, _token];

  /// Creates instance with given header and token values.
  ///
  /// If a header is `null` or empty, throws [ArgumentError].
  /// If a token is `null`, throws [ArgumentError].
  AuthorizationBase(this._httpHeader, this._token) {
    if (_httpHeader == null || _httpHeader.isEmpty) {
      throw ArgumentError.value(
        _httpHeader,
        'httpHeader',
        'cannot be null or empty',
      );
    } else {
      ArgumentError.checkNotNull(_token, 'token');
    }
  }

  /// Converts the instance of this class to [Map] that can be used within an
  /// HTTP request.
  ///
  /// Implementers must not override this method.
  @nonVirtual
  Map<String, String> toMap() {
    return {_httpHeader: _token};
  }

  @override
  String toString() {
    return '$runtimeType ${toMap()}';
  }
}
