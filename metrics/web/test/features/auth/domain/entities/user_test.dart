import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:test/test.dart';

void main() {
  group("User", () {
    test("can't be created with null id", () {
      expect(() => User(id: null), throwsArgumentError);
    });
  });
}
