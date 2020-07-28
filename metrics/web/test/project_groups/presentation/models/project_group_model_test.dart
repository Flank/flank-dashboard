import 'package:collection/collection.dart';
import 'package:metrics/project_groups/presentation/models/project_group_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectGroupModel", () {
    final UnmodifiableListView<String> projectIds = UnmodifiableListView([]);
    const name = 'name';

    test("throws an AssertionError if the given name is null", () {
      expect(
        () => ProjectGroupModel(name: null, projectIds: projectIds),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError if the given project ids is null", () {
      expect(
        () => ProjectGroupModel(name: name, projectIds: null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("successfully creates an instance if the given id is null", () {
      expect(
        () => ProjectGroupModel(id: null, name: name, projectIds: projectIds),
        returnsNormally,
      );
    });

    test("successfully creates an instance on a valid input", () {
      expect(
        () => ProjectGroupModel(id: 'id', name: name, projectIds: projectIds),
        returnsNormally,
      );
    });
  });
}
