import 'dart:convert';
import 'dart:io';

/// A class that holds methods for processing requests in mock servers.
class MockServerUtils {
  /// Writes the given [response].
  static Future<void> writeResponse(
      HttpRequest request, dynamic response) async {
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
}
