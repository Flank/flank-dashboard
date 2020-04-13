import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  const id = 'id';
  const name = 'name';

  const Map<String, dynamic> json = {
    'name': name,
  };

  const ProjectData projectData = ProjectData(
    id: id,
    name: name,
  );

  test(".fromJson() should create a ProjectData instance from a json map", () {
    final projectData = ProjectData.fromJson(json, id);
    expect(projectData, equals(projectData));
  });

  test(".toJson() should convert a ProjectData instance to the json map", () {
    expect(projectData.toJson(), equals(json));
  });
}
