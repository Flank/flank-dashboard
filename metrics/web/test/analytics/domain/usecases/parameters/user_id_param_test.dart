import 'package:metrics/auth/domain/usecases/parameters/user_id_param.dart';
import 'package:test/test.dart';

void main() {
  group("UserIdParam", () {
    const id = 'id';

    test("throws an ArgumentError if the given id is null", () {
      expect(() => UserIdParam(id: null), throwsArgumentError);
    });

    test("creates an instance with the given params", () {
      final userIdParam = UserIdParam(id: id);

      expect(userIdParam.id, equals(id));
    });
  });
}
