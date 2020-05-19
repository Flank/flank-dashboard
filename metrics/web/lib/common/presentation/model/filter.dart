/// An abstract class that represents a filter.
abstract class Filter<T> {
  /// Applies the filter to the given list of data.
  List<T> apply(List<T> list);
}
