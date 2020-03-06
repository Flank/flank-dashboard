import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

abstract class Authorization {
  final String _httpHeader;
  String _token;

  Authorization(this._httpHeader, this._token);

  @nonVirtual
  Map<String, String> toMap() {
    return {_httpHeader: _token};
  }

  @nonVirtual
  void revoke() {
    _token = null;
  }

  @override
  String toString() {
    return '$runtimeType { $_token }';
  }
}

class ApiKeyAuthorization extends Authorization {
  ApiKeyAuthorization(String key, String value) : super(key, value);
}

class BearerAuthorization extends Authorization {
  BearerAuthorization(String token)
      : super(HttpHeaders.authorizationHeader, 'Bearer $token');
}

class BasicAuthorization extends Authorization {
  BasicAuthorization(String username, String password)
      : super(
          HttpHeaders.authorizationHeader,
          'Basic ${_encode(username, password)}',
        );

  static String _encode(String username, String password) {
    final _username = username ?? '';
    final _password = password ?? '';
    return base64Encode(utf8.encode('$_username:$_password'));
  }
}
