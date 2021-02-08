// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// An abstract class that represents a page of a paginated API response.
abstract class Page<T> extends Equatable {
  /// A number of entities that the whole list under pagination contains.
  final int totalCount;

  /// An order number of this page.
  final int page;

  /// A number of entities this page is requested to contain.
  final int perPage;

  /// A URL to fetch the next page.
  final String nextPageUrl;

  /// A list of values for this page.
  final List<T> values;

  /// Indicates whether this page has the next page to fetch.
  bool get hasNextPage => nextPageUrl != null;

  @override
  List<Object> get props => [totalCount, page, perPage, nextPageUrl, values];

  /// Creates a new instance of the [Page].
  const Page({
    this.totalCount,
    this.page,
    this.perPage,
    this.nextPageUrl,
    this.values,
  });

  @override
  String toString() {
    return '$runtimeType '
        '{totalCount: $totalCount, '
        'page: $page, '
        'perPage: $perPage, '
        'nextPageUrl: $nextPageUrl, '
        'values: $values}';
  }
}
