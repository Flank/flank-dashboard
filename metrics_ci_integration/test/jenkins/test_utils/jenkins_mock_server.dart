import 'dart:io';

import '../../test_utils/api_mock_server/api_mock_server.dart';

/// A mock server for Jenkins API.
class JenkinsMockServer extends ApiMockServer {
  @override
  List<RequestHandler> get handlers => [
        RequestHandler.get(),
        RequestHandler.get(),
        RequestHandler.get(),
        RequestHandler.get(),
      ];

  @override
  bool verifyAuthorization(HttpRequest request) {
    final headers = request.headers;
    final authorization = headers[HttpHeaders.authorizationHeader];

    return authorization != null &&
        authorization.isNotEmpty &&
        authorization.contains('Basic');
  }
}
