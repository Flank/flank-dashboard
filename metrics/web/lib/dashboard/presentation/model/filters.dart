import 'package:metrics/dashboard/presentation/model/filter.dart';

/// A class that collects a list of [Filter]s and applies them on demand.
class Filters<T> {
  final List<Filter<T>> _filters = [];

  /// Adds a new [Filter] to the list of filters or replace the old one.
  void addFilter(Filter<T> filter) {
    final oldFilters = _filters
        .where((oldFilter) => oldFilter.runtimeType == filter.runtimeType)
        .toList();

    if (oldFilters.isNotEmpty) {
      final oldFilter = oldFilters.first;
      _filters.remove(oldFilter);
    }

    _filters.add(filter);
  }

  /// Applies each of the [Filter] to filter a list of data.
  List<T> applyAll(List<T> list) {
    if (list == null) return [];

    List<T> filteredList = [...list];

    for (final filter in _filters) {
      filteredList = filter.apply(filteredList);
    }

    return filteredList;
  }
}
