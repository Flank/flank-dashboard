part of junit_xml;

/// A class representing <property> element of JUnitXML report.
///
/// Properties (e.g., environment settings) set during test execution.
/// [name] and [value] are required.
class JUnitProperty {
  final String name;
  final String value;

  JUnitProperty({
    @required this.name,
    @required this.value,
  });
}
