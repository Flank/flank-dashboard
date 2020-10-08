import 'package:equatable/equatable.dart';

/// An abstract class that represents a page of a paginated API request response.
abstract class Page<T> extends Equatable {
  /// A number of entities the whole pagination contains.
  final int totalCount;

  /// An order number of this page.
  final int page;

  /// A number of entities this page contains.
  final int perPage;

  /// A URL of the next page.
  final String nextPageUrl;

  /// Values of this page.
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
}
