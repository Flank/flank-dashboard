import 'package:metrics/dashboard/presentation/model/filter.dart';

class Filters<T> {
  final List<Filter<T>> _filters = [];

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

  List<T> applyAll(List<T> list) {
    if (list == null) return [];

    List<T> filteredList = [...list];

    for (final filter in _filters) {
      filteredList = filter.apply(filteredList);
    }

    return filteredList;
  }
}
