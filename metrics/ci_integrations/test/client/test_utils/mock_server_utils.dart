// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// A class that holds methods for processing requests in mock servers.
class MockServerUtils {
  /// Writes the given [response] to the given [request].
  static Future<void> writeResponse(
    HttpRequest request,
    dynamic response,
  ) async {
    request.response.write(jsonEncode(response));

    await request.response.flush();
    await request.response.close();
  }

  /// Chunks the given [items], limiting to the [limit],
  /// starting from the [pageIndex].
  static List<T> paginate<T>(List<T> items, [int limit, int pageIndex]) {
    if (limit != null && pageIndex != null) {
      final from = (pageIndex - 1) * limit;

      return items.skip(from).take(limit).toList();
    } else if (limit != null) {
      return items.take(limit).toList();
    }

    return items;
  }

  /// Adds a [HttpStatus.notFound] status code to the [HttpRequest.response]
  /// and closes it.
  static Future<void> notFoundResponse(HttpRequest request) async {
    request.response.statusCode = HttpStatus.notFound;

    await request.response.close();
  }

  /// Returns a [Uint8List] to emulate download.
  static Future<void> downloadResponse(HttpRequest request) async {
    await MockServerUtils.writeResponse(request, Uint8List.fromList([]));
  }
}
