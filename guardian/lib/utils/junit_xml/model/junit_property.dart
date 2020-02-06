part of junit_xml;

/// A class representing <property> element of JUnitXML report.
///
/// Properties (e.g., environment settings) set during test execution.
/// [name] and [value] are required.
class JUnitProperty extends Equatable {
  final String name;
  final String value;

  const JUnitProperty({
    @required this.name,
    @required this.value,
  });

  @override
  List<Object> get props => [name, value];
}
