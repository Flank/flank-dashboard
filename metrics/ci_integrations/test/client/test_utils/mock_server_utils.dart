import 'dart:convert';
import 'dart:io';
import 'dart:math';

/// A class that holds methods for processing requests in mock servers.
class MockServerUtils {
  /// Writes the given [response].
  static Future<void> writeResponse(
      HttpRequest request, dynamic response) async {
    request.response.write(jsonEncode(response));

    await request.response.flush();
    await request.response.close();
  }

  /// Returns the `per_page` query parameter of the given [request].
  ///
  /// Returns `null` if the `perPage` is `null`.
  static int extractPerPage(HttpRequest request) {
    final perPage = request.uri.queryParameters['per_page'];

    if (perPage == null) return null;

    return int.tryParse(perPage);
  }

  /// Returns the `page` query parameter of the given [request].
  ///
  /// Returns `null` if the `page` is `null`.
  static int extractPage(HttpRequest request) {
    final page = request.uri.queryParameters['page'];

    if (page == null) return null;

    return int.tryParse(page);
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

  /// Sets the next page url header using the given [request], [itemsCount],
  /// [perPage] and [pageNumber].
  static void setNextPageUrlHeader(
    HttpRequest request,
    int itemsCount,
    int perPage,
    int pageNumber,
  ) {
    final lastPageNumber = _getLastPageNumber(itemsCount, perPage);

    if (pageNumber >= lastPageNumber) return;

    final requestUrl = request.requestedUri.toString();
    final indexOfPageParam = requestUrl.indexOf("&page=");
    final nextPageUrl = requestUrl.replaceRange(
      indexOfPageParam,
      requestUrl.length,
      "&page=${pageNumber + 1}",
    );

    request.response.headers.set('link', '<$nextPageUrl> rel="next"');
  }

  /// Returns the last page number.
  ///
  /// Returns `1` if the given [perPage] or [total] parameter is `null` 
  /// or the given [perPage] is less than zero.
  static int _getLastPageNumber(int total, int perPage) {
    if (perPage == null || perPage <= 0 || total == null) return 1;

    return max((total / perPage).ceil(), 1);
  }
}
