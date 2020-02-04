part of junit_xml;

/// An abstract class representing system data that was written during
/// execution.
abstract class _JUnitSystemData extends Equatable {
  final String text;

  const _JUnitSystemData({this.text});

  @override
  List<Object> get props => [text];
}
