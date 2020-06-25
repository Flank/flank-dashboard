import 'package:metrics/common/presentation/models/project_model.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectModel", () {
    const id = 'id';
    const name = 'name';

    test("successfully creates an instance on a valid input", () {
      expect(() => ProjectModel(id: id, name: name), returnsNormally);
    });

    test("throws an ArgumentError if the given id is null", () {
      expect(() => ProjectModel(id: null, name: name), throwsArgumentError);
    });

    test("throws an ArgumentError if the given name is null", () {
      expect(() => ProjectModel(id: id, name: null), throwsArgumentError);
    });
  });
}
