import 'package:equatable/equatable.dart';

/// An abstract class that represents a page result of an API request.
abstract class Pagination<T> extends Equatable {
  /// Total count of entities in the pagination.
  final int totalCount;

  /// An order number of this page.
  final int page;

  /// Total count of pages in the pagination.
  final int pageCount;

  /// Values of this page.
  final List<T> values;

  @override
  List<Object> get props => [totalCount, page, pageCount, values];

  /// Creates a new instance of the [Pagination].
  const Pagination({
    this.totalCount,
    this.page,
    this.pageCount,
    this.values,
  });
}
